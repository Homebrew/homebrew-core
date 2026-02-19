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
    rebuild 2
    sha256 arm64_tahoe:   "2859f9fc32324373e145969a201a90621c1443001d454d8b0c48ce349356f725"
    sha256 arm64_sequoia: "ada6e9683f3e1c9c4f0dc372680250252cfca61ac77c1f8f6299ad3b8452cfd8"
    sha256 arm64_sonoma:  "66ab0b66299f71ab5f37ad15ac0282b7628af0e9daf210df43120118cb4bc8e4"
    sha256 sonoma:        "42ea1aab95e1cdb360e600e2ef1d0b868a91fa8aba7d0d1e6d437d7388b39d3d"
    sha256 arm64_linux:   "bf35bf67b10fa9755014d6efb0bbe5b882309675846ffce33bf2c9fc824e7453"
    sha256 x86_64_linux:  "a2671d691010f3649f86ef822be69121d1bcb7071f1c04b1959d4b05a4ad7a96"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.14"

  uses_from_macos "unzip" => :build
  uses_from_macos "krb5"

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
    depends_on "zlib-ng-compat"
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
