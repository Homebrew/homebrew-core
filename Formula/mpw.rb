class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://ssl.masterpasswordapp.com/"
  url "https://ssl.masterpasswordapp.com/mpw-2.6-cli-2-0-g30fdb54e.tar.gz"
  version "2.6-cli-2"
  sha256 "c206e512d193a154814a7c5d1faa8dc89e3fa0817b059bd6d957a61dc8ee1e68"
  head "https://github.com/Lyndir/MasterPassword.git"

  bottle do
    cellar :any
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
