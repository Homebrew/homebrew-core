class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://ssl.masterpasswordapp.com/"
  url "https://ssl.masterpasswordapp.com/mpw-2.6-cli-5-0-g344771db.tar.gz"
  version "2.6-cli-5"
  sha256 "954c07b1713ecc2b30a07bead9c11e6204dd774ca67b5bdf7d2d6ad1c4eec170"
  head "https://github.com/Lyndir/MasterPassword.git"

  bottle do
    cellar :any
    sha256 "ae8b265936797778a7cde788377eed89d9eacd267755a0b1186790057a10ff3b" => :high_sierra
    sha256 "b8a106c3c84ff939e928613d4a6ccf7b5234e40ebae1edf15e3cac52d8c2e5ea" => :sierra
    sha256 "9b58425b028a2598932474e1d0c17c13aad57e0a53ae7308c1b38404da8f3331" => :el_capitan
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
