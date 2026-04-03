class GraalvmAT25 < Formula
  desc "JDK distribution with Graal compiler and Native Image"
  homepage "https://www.graalvm.org/"
  url "https://github.com/oracle/graal/archive/refs/tags/graal-25.0.1.tar.gz"
  sha256 "b62409b3b8c8b4d0fee7cdf443a8672157850955783507749e7a916f42d00687"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }

  livecheck do
    url "https://github.com/graalvm/graalvm-ce-builds"
    strategy :github_latest
  end

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "mx" => :build
  depends_on "ninja" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build
  depends_on xcode: :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "cups"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_linux do
    depends_on "alsa-lib"
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
    depends_on "zlib-ng-compat"
  end

  resource "labs-openjdk" do
    url "https://github.com/graalvm/labs-openjdk/archive/refs/tags/25.0.1+8-jvmci-b01.tar.gz"
    version "25.0.1+8-jvmci-b01"
    sha256 "d70295a5066289d32bb5bd080ece50bac8bdeb4252651bb3cf77cd7cd5984dd3"

    livecheck do
      regex(/(\d+(?:\.\d+)+\+\d+-jvmci-b\d+)/i)
      strategy :github_releases
    end
  end

  def install
    boot_jdk = if OS.mac?
      Formula["openjdk"].opt_libexec/"openjdk.jdk/Contents/Home"
    else
      Formula["openjdk"].opt_libexec
    end
    java_options = ENV.delete("_JAVA_OPTIONS")

    labs_openjdk = buildpath/"labs-openjdk"
    resource("labs-openjdk").stage labs_openjdk

    args = %W[
      --disable-warnings-as-errors
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-jvm-variants=server
      --with-native-debug-symbols=none
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-freetype=system
      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system
    ]

    ldflags = %W[
      -Wl,-rpath,#{loader_path.gsub("$", "\\$$")}
      -Wl,-rpath,#{loader_path.gsub("$", "\\$$")}/server
    ]

    labsjdk_version = resource("labs-openjdk").version.to_s
    match = labsjdk_version.match(/(?<java>\d+(?:\.\d+)+)\+(?<build>\d+)-(?<opt>jvmci-b\d+)/)
    odie "Failed to parse LabsJDK version: #{labsjdk_version}" if match.nil?

    args += [
      "--with-version-build=#{match[:build]}",
      "--with-version-pre=",
      "--with-version-opt=#{match[:opt]}",
    ]

    if OS.mac?
      ldflags << "-headerpad_max_install_names"

      # Allow unbundling `freetype` on macOS.
      inreplace labs_openjdk/"make/autoconf/lib-freetype.m4", '= "xmacosx"', '= ""'

      args += %W[
        --enable-dtrace
        --with-freetype-include=#{Formula["freetype"].opt_include}
        --with-freetype-lib=#{Formula["freetype"].opt_lib}
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      args += %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{HOMEBREW_PREFIX}
        --with-fontconfig=#{HOMEBREW_PREFIX}
        --with-stdc++lib=dynamic
      ]
    end
    args << "--with-extra-ldflags=#{ldflags.join(" ")}"

    if DevelopmentTools.clang_build_version == 1600
      args << "--with-extra-cflags=-mllvm -enable-constraint-elimination=0"
    end

    cd labs_openjdk do
      system "bash", "configure", *args

      ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
      system "make", "static-libs-graal-image", "images"
    end

    labsjdk_home = if OS.mac?
      labs_openjdk.glob("build/*/images/jdk-bundle/*").first/"Contents/Home"
    else
      labs_openjdk.glob("build/linux-*-server-release/images/jdk").first
    end
    (labsjdk_home/"lib").install labs_openjdk.glob("build/*/images/static-libs-graal/lib/*")

    odie "Failed to locate built LabsJDK image" if labsjdk_home.empty?

    mx = Formula["mx"].opt_bin/"mx"

    output = buildpath/"build"

    ENV["MX_ALT_OUTPUT_ROOT"] = output
    ENV["JVMCI_VERSION_CHECK"] = "ignore"
    native_image_env = ENV.keys.grep(/^HOMEBREW_/).map { |key| "-E#{key}" }
    ENV.prepend "NATIVE_IMAGE_OPTIONS", native_image_env.join(" ")

    if OS.linux?
      # Upstream also adds musl target, but we only want glibc
      inreplace buildpath/"substratevm/mx.substratevm/mx_substratevm.py",
                "extra_native_targets=['linux-default-glibc', 'linux-default-musl']",
                "extra_native_targets=['linux-default-glibc']"
    end

    mx_args = %W[
      --java-home=#{labsjdk_home}
      --env=ce
    ]

    graalvm_home = nil

    cd "vm" do
      extra_mx_args = %w[--targets=GRAALVM]
      extra_mx_args << "--alt-ldflags=-headerpad_max_install_names" if OS.mac?
      system mx, *mx_args, "build", *extra_mx_args

      graalvm_home = Utils.safe_popen_read(
        mx,
          "--quiet",
          "--no-warning",
          *mx_args,
          "graalvm-home",
      ).chomp
    end
    odie "Failed to locate built GraalVM image" if graalvm_home.empty?
    graalvm_home = Pathname.new(graalvm_home).realpath

    jdk = libexec
    if OS.mac?
      jdk.install graalvm_home.parent.parent => "graalvm.jdk"
      jdk /= "graalvm.jdk/Contents/Home"
    else
      jdk.install graalvm_home.glob("*")
    end

    bin.install_symlink jdk.glob("bin/*")
    include.install_symlink jdk.glob("include/*.h")
    include.install_symlink (jdk/"include"/OS.kernel_name.downcase).glob("*.h")
    man1.install_symlink jdk.glob("man/man1/*")
  end

  test do
    (testpath/"HelloWorld.java").write <<~JAVA
      class HelloWorld {
        public static void main(String[] args) {
          System.out.println("Hello, world!");
        }
      }
    JAVA

    if OS.linux?
      ENV.prepend_path "LIBRARY_PATH", Formula["zlib-ng-compat"].opt_lib
      ENV.prepend "NATIVE_IMAGE_OPTIONS", "-ELIBRARY_PATH"
    end

    system bin/"javac", "HelloWorld.java"
    system bin/"native-image", "-cp", testpath, "-o", "hello", "HelloWorld"

    assert_match "Hello, world!", shell_output("#{testpath}/hello")
  end
end
