class Openj9 < Formula
  desc "High performance, scalable, Java virtual machine"
  homepage "https://www.eclipse.org/openj9/"
  url "https://github.com/eclipse-openj9/openj9/archive/refs/tags/openj9-0.63.0.tar.gz"
  sha256 "7a34308256f7c045a5e71f359ee966212aa3c8c5152e5fad0efa137adf494b68"
  license any_of: [
    "EPL-2.0",
    "Apache-2.0",
    { "GPL-2.0-only" => { with: "Classpath-exception-2.0" } },
    { "GPL-2.0-only" => { with: "OpenJDK-assembly-exception-1.0" } },
  ]
  revision 1

  livecheck do
    url :stable
    regex(/^openj9-(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "de1763fc45a8ed3451c7fc6b83554316f5cee341735d3bf7c783fcd833c4a911"
    sha256 cellar: :any, arm64_tahoe:       "45c3040dc6aeb63bbf2bf5065c7f225cfd2386b8bca4f1979b878ba4f09247a7"
    sha256 cellar: :any, arm64_sequoia:     "fbf000f0b5b4644de780e7714813a559ca6fb26bf4758f29f459f03150ecb0d4"
    sha256               arm64_linux:       "8584107c010be09d03f5cb6df8fc93952048d9929868baa921f59a12708bb6cd"
    sha256               x86_64_linux:      "d9d19e349a6d0dec6548d9d88d3fb3783a3ba1efebbbf34fe74c645804a31399"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "openjdk@25" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "m4" => :build
  uses_from_macos "unzip" => :build
  uses_from_macos "zip" => :build
  uses_from_macos "cups" => :no_linkage
  uses_from_macos "libffi"

  on_macos do
    depends_on xcode: :build # metal support
  end

  on_linux do
    keg_only "it conflicts with openjdk"

    depends_on "libxt" => :build
    depends_on "alsa-lib"
    depends_on "fontconfig" => :no_linkage
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrandr" => :no_linkage
    depends_on "libxrender"
    depends_on "libxtst"
    depends_on "numactl"
    depends_on "zlib-ng-compat"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  resource "omr" do
    url "https://github.com/eclipse-openj9/openj9-omr.git",
        tag:      "openj9-0.63.0",
        revision: "c2a3a9ae0f8f70ab32e489e453114f37136aa67e"

    livecheck do
      formula :parent
    end
  end

  # Keep this on the latest LTS documented at
  # https://github.com/eclipse-openj9/openj9/blob/openj9-#{version}/doc/build-instructions/
  # This matches official documentation and allows us to bootstrap from an OpenJDK formula
  resource "openj9-openjdk-jdk" do
    url "https://github.com/ibmruntimes/openj9-openjdk-jdk25.git",
        tag:      "openj9-0.63.0",
        revision: "3edbf43d7f7b5bd8a7dd24936da867d5ccb5257f"

    livecheck do
      formula :parent
    end
  end

  def install
    # Make sure JDK resource is on latest supported LTS and using correct tag
    jdk_resource = resource("openj9-openjdk-jdk")
    jdk_versions = Dir["doc/build-instructions/*"].filter_map { |path| path[/Build_Instructions_V(\d+)/, 1] }
    jdk_version = jdk_versions.map(&:to_i).max.to_s
    odie "Update respository to JDK #{jdk_version}!" if jdk_version != jdk_resource.url[/jdk(\d+)\.git/, 1]
    odie "Update openj9-openjdk-jdk resource tag!" if jdk_resource.version != version

    boot_jdk = Language::Java.java_home(jdk_version)
    openj9_files = buildpath.children
    (buildpath/"openj9").install openj9_files
    resource("openj9-openjdk-jdk").stage buildpath
    resource("omr").stage buildpath/"omr"
    java_options = ENV.delete("_JAVA_OPTIONS")

    config_args = %W[
      --disable-warnings-as-errors-omr
      --disable-warnings-as-errors-openj9
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-jvm-variants=server
      --with-native-debug-symbols=none
      --with-extra-ldflags=-Wl,-rpath,#{loader_path.gsub("$", "\\$$")},-rpath,#{loader_path.gsub("$", "\\$$")}/server

      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-version-string=#{tap.user}
      --with-vendor-vm-bug-url=#{tap.issues_url}
      --with-version-build=#{revision}
      --without-version-opt
      --without-version-pre

      --with-freetype=system
      --with-giflib=system
      --with-harfbuzz=system
      --with-lcms=system
      --with-libjpeg=system
      --with-libpng=system
      --with-zlib=system

      --enable-ddr=no
      --enable-full-docs=no
    ]
    config_args += if OS.mac?
      # Allow unbundling `freetype` on macOS
      inreplace "make/autoconf/lib-freetype.m4", '= "xmacosx"', '= ""'

      %W[
        --enable-dtrace
        --with-freetype-include=#{formula_opt_include("freetype")}
        --with-freetype-lib=#{formula_opt_lib("freetype")}
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      # Override hardcoded /usr/include directory when checking for numa headers
      inreplace "closed/autoconf/custom-hook.m4", "/usr/include/numa", formula_opt_include("numactl")/"numa"

      %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{formula_opt_prefix("cups")}
        --with-fontconfig=#{formula_opt_prefix("fontconfig")}
        --with-stdc++lib=dynamic
      ]
    end
    # Ref: https://github.com/eclipse-openj9/openj9/issues/13767
    # TODO: Remove once compressed refs mode is supported on Apple Silicon
    config_args << "--with-noncompressedrefs" if OS.mac? && Hardware::CPU.arm?

    ENV["CMAKE_CONFIG_TYPE"] = "Release"

    system "bash", "./configure", *config_args
    system "make", "all", "-j"

    jdk = libexec
    if OS.mac?
      libexec.install Dir["build/*/images/jdk-bundle/*"].first => "openj9.jdk"
      jdk /= "openj9.jdk/Contents/Home"
    else
      libexec.install Dir["build/linux-*-server-release/images/jdk/*"]
    end
    rm jdk/"lib/src.zip"
    rm_r(jdk.glob("**/*.{dSYM,debuginfo}"))

    bin.install_symlink Dir[jdk/"bin/*"]
    include.install_symlink Dir[jdk/"include/*.h"]
    include.install_symlink Dir[jdk/"include"/OS.kernel_name.downcase/"*.h"]
    man1.install_symlink Dir[jdk/"man/man1/*"]
  end

  def caveats
    s = <<~EOS
      This formula provides the latest supported LTS JDK. If you need a specific
      version, then you will have to use a different method to install OpenJ9.
    EOS
    on_macos do
      s += <<~EOS

        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openj9.jdk /Library/Java/JavaVirtualMachines/openj9.jdk
      EOS
    end
    s
  end

  test do
    (testpath/"HelloWorld.java").write <<~JAVA
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    JAVA

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
