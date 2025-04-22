class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https://www.mono-project.com/"
  url "https://dl.winehq.org/mono/sources/mono/mono-6.14.0.tar.xz"
  sha256 "6dd64b3900f5e5d5f55016d89ccf7635c8739cbb33cdb81c1c3b61622e91d510"
  license "Apache-2.0"
  head "https://gitlab.winehq.org/mono/mono.git", branch: "main"

  livecheck do
    url :head
    regex(/^mono[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "6dcc659b8e846bf23593467a53dba803b4bc9c6d6ba6c7a829189b4f88fce1ec"
    sha256 arm64_sonoma:  "3cf381c1a2caf6b4fbdb2c8368581154b7963a7b983dee2cddb0d3ea2b3a308b"
    sha256 arm64_ventura: "7bfdf436e04babe67322882e1b1d46b9a09a5cadcf5a112dd2aa48ed033e5405"
    sha256 sonoma:        "e77d236bbebc33d8f87eada3fc1262fc371a3bfa0095941dd58189ffae156bf1"
    sha256 ventura:       "c4f2bdfaefd9082b2d259cf1bc69d88bbc1a47533fee125db9ebd1ae858add27"
    sha256 arm64_linux:   "dca4990020cc66aaf5c079e681b38d695b2bd48a7f1014fe369af4336b536e6f"
    sha256 x86_64_linux:  "12bf3847064f958e41be8d6c2ee6b7853bbb9fc7d2c0526bc4dfcb494389eb77"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.13"

  uses_from_macos "unzip" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_macos do
    if DevelopmentTools.clang_build_version == 1600
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
  conflicts_with cask: "homebrew/cask-versions/mono-mdk-for-visual-studio"
  conflicts_with "chicken", because: "both install `csc`, `csi` binaries"
  conflicts_with "pedump", because: "both install `pedump` binaries"

  # xbuild requires the .exe files inside the runtime directories to
  # be executable
  skip_clean "lib/mono"

  link_overwrite "lib/mono"
  link_overwrite "lib/cli"

  def install
    ENV.llvm_clang if DevelopmentTools.clang_build_version == 1600

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
