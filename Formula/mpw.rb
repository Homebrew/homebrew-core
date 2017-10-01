class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://ssl.masterpasswordapp.com/"
  url "https://ssl.masterpasswordapp.com/mpw-2.6-cli-3-0-ga85eff42.tar.gz"
  version "2.6-cli-3"
  sha256 "b22290113b5509f9c44dfe8d3604e5a23e3fc840aaf73e053a7bcae734698894"
  revision 1

  head "https://github.com/Lyndir/MasterPassword.git"

  bottle do
    cellar :any
    sha256 "05681e05efdfb32add95d4c7247df77a664e75b1527e7999eb39f1df2de93448" => :high_sierra
    sha256 "bf72e25886a10bdc0db199c572cc9a66673f0a05ade08a808ca4cd9f8d29d11d" => :sierra
    sha256 "5e87ee4db6aad28b461330a23c5d801567103f27c785cb1ce979d14af1512fa8" => :el_capitan
  end

  option "without-json-c", "Disable JSON configuration support"
  option "without-ncurses", "Disable colorized identicon support"

  depends_on "libsodium"
  depends_on "json-c" => :recommended
  depends_on "ncurses" => :recommended

  def install
    cd "platform-independent/cli-c" if build.head?

    ENV["targets"] = "mpw"
    ENV["mpw_json"] = build.with?("json-c") ? "1" : "0"
    ENV["mpw_color"] = build.with?("ncurses") ? "1" : "0"

    system "./build"
    system "./mpw-cli-tests"
    bin.install "mpw"
  end

  test do
    assert_equal "Jejr5[RepuSosp",
      shell_output("#{bin}/mpw -q -Fnone -u 'Robert Lee Mitchell' -M 'banana colored duckling' -tlong -c1 -a3 'masterpasswordapp.com'").strip
  end
end
