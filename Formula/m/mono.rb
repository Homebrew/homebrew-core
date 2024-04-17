class Mono < Formula
  desc "Cross platform, open source .NET development framework"
  homepage "https://www.mono-project.com/"
  url "https://download.mono-project.com/sources/mono/mono-6.12.0.199.tar.xz"
  sha256 "c0850d545353a6ba2238d45f0914490c6a14a0017f151d3905b558f033478ef5"
  license "MIT"

  livecheck do
    url "https://www.mono-project.com/download/stable/"
    regex(/href=.*?(\d+(?:\.\d+)+)[._-]macos/i)
  end

  bottle do
    sha256 arm64_sonoma:   "fecd50c2c2290c51fc84addd9bac77dd74b3c7901b5a8329e95322bf099cd7d6"
    sha256 arm64_ventura:  "a3682350a932ff3812b57b3cd5671971a3cda31ddae14ccbe0a263f666222507"
    sha256 arm64_monterey: "07f9edfaf51fb758b0af90349d33ab6abc7cfc3d95596b2ad26a55fe9ebd62e8"
    sha256 sonoma:         "fc2d7386cf53876efd5edd0eafa568a3c82b13322fb2c27cecbe96a3477287ff"
    sha256 ventura:        "df4634d1564955ffa5b51e5e3c8efd78f5feaf82b71cfb3476e26d920a1b1b3a"
    sha256 monterey:       "54f6aa2e1caa371de1ba5fc6f2b3e4e8423a2669249dca543d4995900693834e"
    sha256 x86_64_linux:   "003fac1632e75740b9d6e105471e4c5212a22d0adbeead4e2e73c03f70573f84"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "python@3.12"

  uses_from_macos "unzip" => :build
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  conflicts_with "xsd", because: "both install `xsd` binaries"
  conflicts_with cask: "mono-mdk"
  conflicts_with cask: "homebrew/cask-versions/mono-mdk-for-visual-studio"

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

    # Remove use of -flat_namespace. Upstreamed at
    # https://github.com/mono/mono/pull/21257
    inreplace "mono/profiler/Makefile.am", "-Wl,suppress -Wl,-flat_namespace", "-Wl,dynamic_lookup"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-nls"
    system "make"
    system "make", "install"
    # mono-gdb.py and mono-sgen-gdb.py are meant to be loaded by gdb, not to be
    # run directly, so we move them out of bin
    libexec.install bin/"mono-gdb.py", bin/"mono-sgen-gdb.py"
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
    (testpath/test_name).write <<~EOS
      public class Hello1
      {
         public static void Main()
         {
            System.Console.WriteLine("#{test_str}");
         }
      }
    EOS
    shell_output("#{bin}/mcs #{test_name}")
    output = shell_output("#{bin}/mono hello.exe")
    assert_match test_str, output.strip
  end
end
