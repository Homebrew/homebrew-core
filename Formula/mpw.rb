class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://ssl.masterpasswordapp.com/"
  url "https://ssl.masterpasswordapp.com/mpw-2.6-cli-3-0-ga85eff42.tar.gz"
  version "2.6-cli-3"
  sha256 "b22290113b5509f9c44dfe8d3604e5a23e3fc840aaf73e053a7bcae734698894"
  head "https://github.com/Lyndir/MasterPassword.git"

  bottle do
    cellar :any
    sha256 "a0730bb6569b8ff04987db2e48540201520c15a4b5c44acc89b322672d1e939f" => :high_sierra
    sha256 "126ef4edcb6095bb0a6961986de07b23daec5dbe218e8895330d71df12c69456" => :sierra
    sha256 "4be101a8af0048f3542ca880420da11c71b1b7efe634d9fbac7569a75b2ee828" => :el_capitan
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
