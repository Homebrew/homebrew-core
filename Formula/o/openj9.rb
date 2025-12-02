class Openj9 < Formula
  desc "High performance, scalable, Java virtual machine"
  homepage "https://www.eclipse.org/openj9/"
  url "https://github.com/eclipse-openj9/openj9.git",
      tag:      "openj9-0.48.0",
      revision: "1d5831436ec378c7dd9f57415bec39d3f5817d57"
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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "cb5163911364e7dd848768a634f55c99187f51abb9e2d7ece4c1b3f2822b7d71"
    sha256 cellar: :any, arm64_sequoia: "29f9ddebb6f36fd0b5bca683d6abee61bc77741f93c6c6e61ec8e990d4e667df"
    sha256 cellar: :any, arm64_sonoma:  "438e8bcee5e83f44283299e7c303fa83f104d110fb366f4781cc36ba78eaa60f"
    sha256 cellar: :any, arm64_ventura: "2ce146ac5d3dd24c2128a3a415ccd7cbde196fba5886a9cfe9b17456f23acef4"
    sha256 cellar: :any, sonoma:        "556ef126e9179af15826e7eb1877b6733b951990808b4ae5b8875d3ca0927119"
    sha256 cellar: :any, ventura:       "6ebb3a8c650f109ec0c0769e8d8da7217852fb26099908abd7446a81c0244132"
    sha256               arm64_linux:   "bb9d01b54445f63cb3ae6d6fe095e08b9c3442bcc15f2dac9858cc34d951409b"
    sha256               x86_64_linux:  "4a236476593a25dd692c85fc8ded426ddb7d5e63995b42e6c5aa8632a13934d2"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "harfbuzz"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "little-cms2"

  uses_from_macos "m4" => :build
  uses_from_macos "cups"
  uses_from_macos "libffi"
  uses_from_macos "unzip"
  uses_from_macos "zip"
  uses_from_macos "zlib"

  on_linux do
    keg_only "it conflicts with openjdk"

    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
    depends_on "numactl"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  # From https://github.com/eclipse-openj9/openj9/blob/openj9-#{version}/doc/build-instructions/
  # We use JDK 22 to bootstrap.
  resource "boot-jdk" do
    on_macos do
      on_arm do
        url "https://github.com/AdoptOpenJDK/semeru22-binaries/releases/download/jdk-22.0.1%2B8_openj9-0.45.0/ibm-semeru-open-jdk_aarch64_mac_22.0.1_8_openj9-0.45.0.tar.gz"
        sha256 "623cc15daa3b4c7f21d47f225c94a163e2261074cc3c11f30d2938fc249b9355"
      end
      on_intel do
        url "https://github.com/AdoptOpenJDK/semeru22-binaries/releases/download/jdk-22.0.1%2B8_openj9-0.45.0/ibm-semeru-open-jdk_x64_mac_22.0.1_8_openj9-0.45.0.tar.gz"
        sha256 "f0e459df70b5a3c8fc0abc099d5c06a596da40b95f8226d76474516a646a3861"
      end
    end
    on_linux do
      on_arm do
        url "https://github.com/AdoptOpenJDK/semeru22-binaries/releases/download/jdk-22.0.1%2B8_openj9-0.45.0/ibm-semeru-open-jdk_aarch64_linux_22.0.1_8_openj9-0.45.0.tar.gz"
        sha256 "feb2734b519990d730c577254df5a97f7110bb851994ce775977894a9fdc22c7"
      end
      on_intel do
        url "https://github.com/AdoptOpenJDK/semeru22-binaries/releases/download/jdk-22.0.1%2B8_openj9-0.45.0/ibm-semeru-open-jdk_x64_linux_22.0.1_8_openj9-0.45.0.tar.gz"
        sha256 "6e54d984bc0c058ffb7a604810dfffba210d79e12855e5c61e9295fedeff32db"
      end
    end
  end

  resource "omr" do
    url "https://github.com/eclipse-openj9/openj9-omr.git",
        tag:      "openj9-0.48.0",
        revision: "d10a4d553a3cfbf35db0bcde9ebccb24cdf1189f"

    # Fix syntax error in OptionFlagArray class definition
    # Remove when bumped to openj9-0.53.0 or later.
    patch do
      url "https://github.com/eclipse-openj9/openj9-omr/commit/29203c807abe45fce56e70b93e80ebaef22b0844.patch?full_index=1"
      sha256 "044a26ac76fafc536feb8dfc24c521ef26a66c98b78948f4571293a41ede24ca"
    end
  end

  resource "openj9-openjdk-jdk" do
    url "https://github.com/ibmruntimes/openj9-openjdk-jdk22.git",
        tag:      "openj9-0.46.1",
        revision: "b77827589c585158319340068dae8497b75322c6"
  end

  # Fix build on Clang 17+. Backport of:
  # https://github.com/itf/libffi/commit/3065c530d3aa50c2b5ee9c01f88a9c0b61732805
  patch :DATA

  def install
    openj9_files = buildpath.children
    (buildpath/"openj9").install openj9_files
    resource("openj9-openjdk-jdk").stage buildpath
    resource("omr").stage buildpath/"omr"
    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage boot_jdk
    boot_jdk /= "Contents/Home" if OS.mac?
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
        --with-freetype-include=#{Formula["freetype"].opt_include}
        --with-freetype-lib=#{Formula["freetype"].opt_lib}
        --with-sysroot=#{MacOS.sdk_path}
      ]
    else
      # Override hardcoded /usr/include directory when checking for numa headers
      inreplace "closed/autoconf/custom-hook.m4", "/usr/include/numa", Formula["numactl"].opt_include/"numa"

      %W[
        --with-x=#{HOMEBREW_PREFIX}
        --with-cups=#{Formula["cups"].opt_prefix}
        --with-fontconfig=#{Formula["fontconfig"].opt_prefix}
        --with-stdc++lib=dynamic
      ]
    end
    # Ref: https://github.com/eclipse-openj9/openj9/issues/13767
    # TODO: Remove once compressed refs mode is supported on Apple Silicon
    config_args << "--with-noncompressedrefs" if OS.mac? && Hardware::CPU.arm?

    ENV["CMAKE_CONFIG_TYPE"] = "Release"
    ENV["CMAKE_POLICY_VERSION_MINIMUM"] = "3.5"

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
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openj9.jdk /Library/Java/JavaVirtualMachines/openj9.jdk
      EOS
    end
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

__END__
diff --git a/runtime/libffi/aarch64/sysv.S b/runtime/libffi/aarch64/sysv.S
index eeaf3f8514..329889cfb3 100644
--- a/runtime/libffi/aarch64/sysv.S
+++ b/runtime/libffi/aarch64/sysv.S
@@ -76,8 +76,8 @@ SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.  */
    x5 closure
 */

-	cfi_startproc
 CNAME(ffi_call_SYSV):
+	cfi_startproc
 	/* Sign the lr with x1 since that is where it will be stored */
 	SIGN_LR_WITH_REG(x1)

@@ -268,8 +268,8 @@ CNAME(ffi_closure_SYSV_V):
 #endif

 	.align	4
-	cfi_startproc
 CNAME(ffi_closure_SYSV):
+	cfi_startproc
 	SIGN_LR
 	stp     x29, x30, [sp, #-ffi_closure_SYSV_FS]!
 	cfi_adjust_cfa_offset (ffi_closure_SYSV_FS)
@@ -500,8 +500,8 @@ CNAME(ffi_go_closure_SYSV_V):
 #endif

 	.align	4
-	cfi_startproc
 CNAME(ffi_go_closure_SYSV):
+	cfi_startproc
 	stp     x29, x30, [sp, #-ffi_closure_SYSV_FS]!
 	cfi_adjust_cfa_offset (ffi_closure_SYSV_FS)
 	cfi_rel_offset (x29, 0)
