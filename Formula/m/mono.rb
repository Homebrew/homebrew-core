class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https://www.mono-project.com/"
  url "https://dl.winehq.org/mono/sources/mono/mono-6.14.1.tar.xz"
  sha256 "3024c97c0bc8cbcd611c401d5f994528704108ceb31f31b28dea4783004d0820"
  license "Apache-2.0"
  compatibility_version 1
  head "https://gitlab.winehq.org/mono/mono.git", branch: "main"

  livecheck do
    url :head
    regex(/^mono[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 3
    sha256 arm64_golden_gate: "bb3ced09c44ad6a265f35fbc4538151f340fe44c915042862b7557cd84f9d29d"
    sha256 arm64_tahoe:       "599ff3c36efca4e2571c617384f96792f5286d6792b8bf1c7e48270f92c2480e"
    sha256 arm64_sequoia:     "0cb30adb311d1acc39002eb8a69614b84462f3c4a9a4f799d0fce0acbed38c59"
    sha256 arm64_linux:       "7acf75f6898683b38a47806cac02d04bb73323b77d651fbf34b8eec48615782e"
    sha256 x86_64_linux:      "cc7138d13f44f75943f003dab7d7305ad79f9304e5607d2299983f1bd40441d2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.15"

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

  post_install_steps do
    on_linux do
      run "cert-sync", args: ["{{HOMEBREW_PREFIX}}/etc/ca-certificates/cert.pem"], base: :bin
    end
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
