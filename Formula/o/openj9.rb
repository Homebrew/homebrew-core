class Openj9 < Formula
  desc "High performance, scalable, Java virtual machine"
  homepage "https://www.eclipse.org/openj9/"
  url "https://github.com/eclipse-openj9/openj9/archive/refs/tags/openj9-0.57.0.tar.gz"
  sha256 "84650d5f8e623bec413b72e5486a40f0b3dcc71435fa4dfe5b9bba5bea4c398d"
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
    sha256 cellar: :any, arm64_tahoe:   "6003734f9820a7cf2ecd84c2e935c0fd46430278eaeeee0278d4968b39e78f12"
    sha256 cellar: :any, arm64_sequoia: "c6374bea84fa0ea5d4ddb1ed630961f37b3eb3f4cff190f100a321c3f3e4bfae"
    sha256 cellar: :any, arm64_sonoma:  "a5b5cc2c8ece4eba47b1c7dfec6659d87493ccb3111563c553a25bef37875fb8"
    sha256 cellar: :any, sonoma:        "40123706274b3123b211881e250e220e5be8051a08507514ff0d5ea976b891a7"
    sha256               arm64_linux:   "14d82b2581a27cb50d2906087a25b1d8d69d27514b500a4b80350ef1854ef442"
    sha256               x86_64_linux:  "f6c07e1ebf0cc612a87525cd8ac92d7c1133d4a2a9f3647ce90454542d1a2d05"
  end

  keg_only :shadowed_by_macos

  depends_on "autoconf" => :build
  depends_on "bash" => :build
  depends_on "cmake" => :build
  depends_on "openjdk" => :build # TODO: will need to use `openjdk@25` when JDK 26 is released
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

  on_linux do
    keg_only "it conflicts with openjdk"

    depends_on "alsa-lib"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
    depends_on "numactl"
    depends_on "zlib-ng-compat"
  end

  on_intel do
    depends_on "nasm" => :build
  end

  resource "omr" do
    url "https://github.com/eclipse-openj9/openj9-omr/archive/refs/tags/openj9-0.57.0.tar.gz"
    sha256 "7da11f270722c3d99570ef53af6dd84ae5ca865c7f9bc2982c4c415b7cb585c9"

    livecheck do
      formula :parent
    end
  end

  # Keep this on the latest LTS documented at
  # https://github.com/eclipse-openj9/openj9/blob/openj9-#{version}/doc/build-instructions/
  # This matches official documentation and allows us to bootstrap from an OpenJDK formula
  resource "openj9-openjdk-jdk" do
    url "https://github.com/ibmruntimes/openj9-openjdk-jdk25.git",
        tag:      "openj9-0.57.0",
        revision: "394c3b425206fdffa3e09e1d874d1905c1957ebb"

    livecheck do
      formula :parent
    end
  end

  # Fix build on Clang 17+. Backport of:
  # https://github.com/itf/libffi/commit/3065c530d3aa50c2b5ee9c01f88a9c0b61732805
  patch :DATA

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
