class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://ssl.masterpasswordapp.com/"
  url "https://ssl.masterpasswordapp.com/mpw-2.6-cli-4-0-gf8043ae1.tar.gz"
  version "2.6-cli-4"
  sha256 "90480c0994cccdaa6637cc311e2092e5b6f2fdc751b58d218a6bd61e4603b2a0"

  head "https://github.com/Lyndir/MasterPassword.git"

  bottle do
    cellar :any
    sha256 "2362b64cc103b6773e0f324fccce8060e8e616346da2bd1860ed6550493c6e31" => :high_sierra
    sha256 "0b309a132855ca40b5ecd429c8495498528e19f12a47b45398ed5375e01d1329" => :sierra
    sha256 "d5a6c9f23018a3620fc4e0e8306c5eb5f700510ac048f55fe59a59c15f377f2f" => :el_capitan
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
