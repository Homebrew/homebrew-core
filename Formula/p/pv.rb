class Pv < Formula
  desc "Monitor data's progress through a pipe"
  homepage "https://www.ivarch.com/programs/pv.shtml"
  url "https://www.ivarch.com/programs/sources/pv-1.9.31.tar.gz"
  sha256 "a35e92ec4ac0e8f380e8e840088167ae01014bfa008a3a9d6506b848079daedf"
  license "Artistic-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?pv[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "ebca476acb2b46ba13fa847aac59da72143548df1ba49f4d31682598a702d160"
    sha256 arm64_sonoma:  "010b70c9a9684a6572a72fd581f2a3e4ba435e029f065fa783c0b659bead01a0"
    sha256 arm64_ventura: "772ab52f0c8e255fa4ea867b87afac47b91e34b738db16dd1ccf71e9e19b1b65"
    sha256 sonoma:        "acda1ee6e20e5c17f04eeef228b0a5f75268e1e035e8f0347e79780eacb97a56"
    sha256 ventura:       "75acce5dd4bd5efae2066e4e89bc6c99940f51d1dd0196bb6e15e06217d7b59c"
    sha256 arm64_linux:   "f3610ebfcb754f358faca339e38562f37666d448d4a134df1720b5fbab736e58"
    sha256 x86_64_linux:  "04aded1e1b833d8f7b2921ac23e2d8ddfae955eb18e6de47ec2b08150c548b94"
  end

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    progress = pipe_output("#{bin}/pv -ns 4 2>&1 >/dev/null", "beer")
    assert_equal "100", progress.strip

    assert_match version.to_s, shell_output("#{bin}/pv --version")
  end
end
