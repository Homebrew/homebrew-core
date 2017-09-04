class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://ssl.masterpasswordapp.com/"
  url "https://ssl.masterpasswordapp.com/mpw-2.6-cli-2-0-g30fdb54e.tar.gz"
  version "2.6-cli-2"
  sha256 "c206e512d193a154814a7c5d1faa8dc89e3fa0817b059bd6d957a61dc8ee1e68"
  head "https://github.com/Lyndir/MasterPassword.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "03d033152f2da377654b0dabd823e304827fad58d08ab3c945978f61c5aba5bf" => :sierra
    sha256 "23055a80705a261f15bf1f36cce7919dda62457b06c4af1bc1137ed172aa6844" => :el_capitan
    sha256 "34b22632d5d225bcbc6b24dada0ce2b526c6739b9b0e55e9b1209f265d0a6888" => :yosemite
    sha256 "290586cc77c94562e08977227209e16b9b821cb84e068bcf748b2e0ce07bdb0f" => :mavericks
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
