class CodesignRequirement < Requirement
  include FileUtils
  fatal true

  satisfy(:build_env => false) do
    mktemp do
      cp "/usr/bin/false", "gdb_check"
      quiet_system "/usr/bin/codesign", "-f", "-s", "gdb_codesign", "--dryrun", "gdb_check"
    end
  end

  def message
    <<-EOS.undent
    gdb_codesign identity is needed to build with automated signing.
      See: https://llvm.org/svn/llvm-project/lldb/trunk/docs/code-signing.txt
    EOS
  end
end

class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.0.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-8.0.1.tar.xz"
  sha256 "3dbd5f93e36ba2815ad0efab030dcd0c7b211d7b353a40a53f4c02d7d56295e3"

  bottle do
    sha256 "e98ad847402592bd48a9b1468fefb2fac32aff1fa19c2681c3cea7fb457baaa0" => :high_sierra
    sha256 "0fdd20562170c520cfb16e63d902c13a01ec468cb39a85851412e7515b6241e9" => :sierra
    sha256 "f51136c70cff44167dfb8c76b679292d911bd134c2de3fef40777da5f1f308a0" => :el_capitan
    sha256 "2b32a51703f6e254572c55575f08f1e0c7bc2f4e96778cb1fa6582eddfb1d113" => :yosemite
  end

  deprecated_option "with-brewed-python" => "with-python"
  deprecated_option "with-guile" => "with-guile@2.0"

  option "with-python", "Use the Homebrew version of Python; by default system Python is used"
  option "with-version-suffix", "Add a version suffix to program"
  option "with-all-targets", "Build with support for all targets"
  option "with-code-signing", "Codesign executable to provide unprivileged process attachment"

  depends_on "pkg-config" => :build
  depends_on "python" => :optional
  depends_on "guile@2.0" => :optional

  depends_on CodesignRequirement if build.with? "code-signing"

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
    ]

    args << "--with-guile" if build.with? "guile@2.0"
    args << "--enable-targets=all" if build.with? "all-targets"

    if build.with? "python"
      args << "--with-python=#{HOMEBREW_PREFIX}"
    else
      args << "--with-python=/usr"
    end

    if build.with? "version-suffix"
      args << "--program-suffix=-#{version.to_s.slice(/^\d/)}"
    end

    system "./configure", *args
    system "make"

    # Don't install bfd or opcodes, as they are provided by binutils
    inreplace ["bfd/Makefile", "opcodes/Makefile"], /^install:/, "dontinstall:"

    system "make", "install"

    if build.with? "code-signing"
      # Building gdb requires a code signing certificate.
      # The instructions provided by llvm creates this certificate in the
      # user's login keychain. Unfortunately, the login keychain is not in
      # the search path in a superenv build. The following three lines add
      # the login keychain to ~/Library/Preferences/com.apple.security.plist,
      # which adds it to the superenv keychain search path.
      mkdir_p "#{ENV["HOME"]}/Library/Preferences"
      username = ENV["USER"]
      system "security", "list-keychains", "-d", "user", "-s", "/Users/#{username}/Library/Keychains/login.keychain"
      system "/usr/bin/codesign", "-f", "-s", "gdb_codesign", bin/"gdb"
    end
  end

  if build.without? "code-signing"
    def caveats; <<-EOS.undent
      gdb requires special privileges to access Mach ports.
      You will need to codesign the binary. For instructions, see:

        https://sourceware.org/gdb/wiki/BuildingOnDarwin

      Alternatively, build with the --with-code-siging option.

      On 10.12 (Sierra) or later with SIP, you need to run this:

        echo "set startup-with-shell off" >> ~/.gdbinit
      EOS
    end
  else
    def caveats; <<-EOS.undent
      gdb has been codesigned and is ready to use. Additionally, on 10.12 (Sierra)
      or later with SIP, you need to run this:

        echo "set startup-with-shell off" >> ~/.gdbinit
      EOS
    end
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
