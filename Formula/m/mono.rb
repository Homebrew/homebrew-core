class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https://www.mono-project.com/"
  url "https://dl.winehq.org/mono/sources/mono/mono-6.14.1.tar.xz"
  sha256 "3024c97c0bc8cbcd611c401d5f994528704108ceb31f31b28dea4783004d0820"
  license "Apache-2.0"
  head "https://gitlab.winehq.org/mono/mono.git", branch: "main"

  livecheck do
    url :head
    regex(/^mono[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "20022e3bf3f9e4b1bcad7a4f4903565049164a9c2691e6b2585af777c50ea7d6"
    sha256 arm64_sequoia: "409206a1822a5d6cf3646c8f0f5b8fe94c7f41558d80383da49eb3346d2f6472"
    sha256 arm64_sonoma:  "6ef5f47269cf14ad82b94fb8cef2a679ff2bb990a8f74b42e407b5af8beec387"
    sha256 sonoma:        "d48e2373e32762b53a03da1ce174f40de2a88e0e0027e85484bd7123c2558e2d"
    sha256 arm64_linux:   "44fbfa33608470d00c50a4e1a7b27dd4d4c38a030fb3b2a6b9a7c117cdd259e7"
    sha256 x86_64_linux:  "f261ecc67558b51d217ca044e51699a739780bfeab4563502f34bbbf7be7fa62"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.14"

  uses_from_macos "unzip" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    if DevelopmentTools.clang_build_version >= 1600
      depends_on "llvm" => :build

      fails_with :clang do
        cause <<~EOS
          Got a segv while executing native code. This usually indicates
          a fatal error in the mono runtime or one of the native libraries
          used by your application.
        EOS
      end
    end
  end

  on_linux do
    depends_on "ca-certificates"
  end

  conflicts_with "xsd", because: "both install `xsd` binaries"
  conflicts_with cask: "mono-mdk"
  conflicts_with cask: "mono-mdk-for-visual-studio"
  conflicts_with "chicken", because: "both install `csc`, `csi` binaries"
  conflicts_with "pedump", because: "both install `pedump` binaries"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  link_overwrite "lib/mono"
  link_overwrite "lib/cli"

  def install
    ENV.llvm_clang if DevelopmentTools.clang_build_version >= 1600

    # Replace hardcoded /usr/share directory. Paths like /usr/share/.mono,
    # /usr/share/.isolatedstorage, and /usr/share/template are referenced in code.
    inreplace_files = %w[
      external/corefx/src/System.Runtime.Extensions/src/System/Environment.Unix.cs
      mcs/class/corlib/System/Environment.cs
      mcs/class/corlib/System/Environment.iOS.cs
      man/mono-configuration-crypto.1
      man/mono.1
      man/mozroots.1
    ]
    inreplace inreplace_files, %r{/usr/share(?=[/"])}, pkgshare

    system "./autogen.sh", "--disable-nls",
                           "--disable-silent-rules",
                           *std_configure_args
    system "make"
    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin/"mono-gdb.py", bin/"mono-sgen-gdb.py"
  end

  def post_install
    system bin/"cert-sync", Formula["ca-certificates"].pkgetc/"cert.pem" if OS.linux?
  end

  def caveats
    <<~EOS
      To use the assemblies from other formulae you need to set:
        export MONO_GAC_PREFIX="#{HOMEBREW_PREFIX}"
    EOS
  end

  test do
    test_str = "Hello Homebrew"
    test_name = "hello.cs"
    (testpath/test_name).write <<~CSHARP
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    CSHARP
    shell_output("#{bin}/mcs #{test_name}")
    output = shell_output("#{bin}/mono hello.exe")
    assert_match test_str, output.strip
  end
end
