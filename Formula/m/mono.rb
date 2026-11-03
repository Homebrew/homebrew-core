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
    rebuild 4
    sha256 arm64_golden_gate: "710ad3032ee9493e961458001dfb503eb161bb274514b0712d57c241e9a5e528"
    sha256 arm64_tahoe:       "f5ea5ba70d06035e98457f490a33ac2e5e287c7fee8e788df009e6698702ed97"
    sha256 arm64_sequoia:     "8a45ead0f2fb2e11f539178f69c96f2a6957c06823125d400bdd7faa04dfc27f"
    sha256 arm64_linux:       "f24075baf414741460536dd1da9d1eb19285daa5aca034dd7d1e12de7714a3f5"
    sha256 x86_64_linux:      "872a93b5529f12e089f5711ac6fb255c0da9cd69117c2c54b78fcd60cf95842f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "unzip" => :build
  uses_from_macos "krb5"
  uses_from_macos "python"

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

  deny_network_access!

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
