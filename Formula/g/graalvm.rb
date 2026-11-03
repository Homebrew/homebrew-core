class Graalvm < Formula
  desc "JDK distribution with Graal compiler and Native Image"
  homepage "https://www.graalvm.org/"
  url "https://github.com/oracle/graal/archive/refs/tags/graal-25.5.5.0.3.tar.gz"
  sha256 "aeeedf50bf8c65a150fab0ac719b2c7a829c206ec314af62296a89724aa899ba"
  license "GPL-2.0-only" => { with: "Classpath-exception-2.0" }
  compatibility_version 1

  livecheck do
    url "https://github.com/graalvm/graalvm-ce-builds"
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4276f6de7a07d530228b4960a659b8cf6a2133ed112cbff9a840cd22ab20fd05"
    sha256 cellar: :any, arm64_tahoe:       "7cb69ac3709c9e24f6e47394e97ddccc26e60a21a7d7db4a39f4fa35e6c153e8"
    sha256 cellar: :any, arm64_sequoia:     "cd1fd8d4e043ac5663fc7cd843fd18624a99c760e819b96e3412ae6b539ba001"
    sha256               arm64_linux:       "0698ef97287afe7c884a04fb0437f587ef5f20dc3d8465ae92fb03c9cd378176"
    sha256               x86_64_linux:      "989904fc55ee5a0d6741a34172933ad849141612b953b976cdf22f0e041e2adf"
  end

  keg_only "installs a JDK which shadows openjdk"

  depends_on "autoconf" => :build
  depends_on "mx" => :build
  depends_on "ninja" => :build
  depends_on "openjdk@25" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "unzip" => :build
  uses_from_macos "zip" => :build
  uses_from_macos "cups" => :no_linkage

  on_macos do
    depends_on xcode: :build # for metal
    depends_on arch: :arm64
  end

  on_linux do
    depends_on "libxt" => :build
    depends_on "alsa-lib"
    depends_on "fontconfig" => :no_linkage
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrandr" => :no_linkage
    depends_on "libxrender"
    depends_on "libxtst"
    depends_on "zlib-ng-compat"
  end

  resource "labs-openjdk" do
    url "https://github.com/graalvm/labs-openjdk/archive/refs/tags/jvmci-25.5-b26.tar.gz"
    version "25.5-b26"
    sha256 "722989310da5d47fea8639a43e3c8884a06909f5f7777a4b36f9e5108b66cae4"

    livecheck do
      url "https://raw.githubusercontent.com/oracle/graal/refs/tags/graal-#{LATEST_VERSION}/common.json"
      regex(/jvmci[._-]v?(\d+(?:\.\d+)+-b\d+)$/i)
      strategy :json do |json, regex|
        json.dig("jdks", "labsjdk-ce-latest", "version")&.[](regex, 1)
      end
    end
  end

  def install
    boot_jdk = Language::Java.java_home("25")
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

    labsjdk_version = JSON.parse(File.read("common.json")).dig("jdks", "labsjdk-ce-latest", "version")
    match = labsjdk_version.match(/(?<java>\d+(?:\.\d+)*)\+(?<build>\d+)-(?<opt>jvmci(?:-\d+(?:\.\d+)*)?-b\d+)/)
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
        --with-freetype-include=#{formula_opt_include("freetype")}
        --with-freetype-lib=#{formula_opt_lib("freetype")}
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

    cd labs_openjdk do
      system "bash", "configure", *args

      ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
      system "make", "static-libs-graal-image"
      system "make", "images"
    end

    labsjdk_home = if OS.mac?
      labs_openjdk.glob("build/*/images/jdk-bundle/*").first/"Contents/Home"
    else
      labs_openjdk.glob("build/linux-*-server-release/images/jdk").first
    end
    (labsjdk_home/"lib").install labs_openjdk.glob("build/*/images/static-libs-graal/lib/*")

    odie "Failed to locate built LabsJDK image" if labsjdk_home.empty?

    mx = formula_opt_bin("mx")/"mx"

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
      ENV.prepend_path "LIBRARY_PATH", formula_opt_lib("zlib-ng-compat")
      ENV.prepend "NATIVE_IMAGE_OPTIONS", "-ELIBRARY_PATH"
    end

    system bin/"javac", "HelloWorld.java"
    system bin/"native-image", "-cp", testpath, "-o", "hello", "HelloWorld"

    assert_match "Hello, world!", shell_output("#{testpath}/hello")
  end
end
