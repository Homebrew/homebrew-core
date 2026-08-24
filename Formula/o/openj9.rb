class Openj9 < Formula
  desc "High performance, scalable, Java virtual machine"
  homepage "https://www.eclipse.org/openj9/"
  url "https://github.com/eclipse-openj9/openj9/archive/refs/tags/openj9-0.60.0.tar.gz"
  sha256 "6f9f2a6afaaaf88f3eedd5224b303926f3386b96337c5d28bd71dae39e87f80d"
  license any_of: [
    "EPL-2.0",
    "Apache-2.0",
    { "GPL-2.0-only" => { with: "Classpath-exception-2.0" } },
    { "GPL-2.0-only" => { with: "OpenJDK-assembly-exception-1.0" } },
  ]

  livecheck do
    url :stable
    regex(/^openj9-(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d661591ff1c13949725265740f176cf79ddc82b5a13fbd95d888a1913d360b9b"
    sha256 cellar: :any, arm64_sequoia: "7fd72691b782fe89b4adc42e6c5ecc95f038fd1cfb87425b11849cda8756f095"
    sha256 cellar: :any, arm64_sonoma:  "745cc887bf4ad1c1537f0ad2421edb982e19cdda2d2668587cdc147fcb57f2aa"
    sha256 cellar: :any, sonoma:        "2b4b07928126aeb9792d919e2850323e3b4439cd22352f3bcab38b86f2339566"
    sha256               arm64_linux:   "44e2bb4d91fcd04e17cd95fe4b381ba8a725c896b3e83e501776d224f41d05d0"
    sha256               x86_64_linux:  "8fe0396bf169be086335fa3cf2a5c25eba2df0e052c10ca29c76f158d574fae2"
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
        branch:   "v0.60.0-release",
        revision: "2e3166f7afc61f577ccaa63b85444b63b82491f7"
    version "0.60.0"

    livecheck do
      formula :parent
    end
  end

  # Keep this on the latest LTS documented at
  # https://github.com/eclipse-openj9/openj9/blob/openj9-#{version}/doc/build-instructions/
  # This matches official documentation and allows us to bootstrap from an OpenJDK formula
  resource "openj9-openjdk-jdk" do
    url "https://github.com/ibmruntimes/openj9-openjdk-jdk25.git",
        branch:   "v0.60.0-release",
        revision: "e4aaece3226fa3b588146d3ef3f52caa7afc3330"
    version "0.60.0"

    livecheck do
      formula :parent
    end
  end

  # Fix build on Clang 17+
  patch do
    url "https://github.com/eclipse-openj9/openj9/commit/7936ac3ce51ff78e2853b35dce94cb3d4371596b.patch?full_index=1"
    sha256 "998999131d989b1cf15c6e73650ba66505206e9635f925434182dc709c5d501a"
    type :backport
    resolves "https://github.com/eclipse-openj9/openj9/pull/24278"
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
