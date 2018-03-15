class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://ssl.masterpasswordapp.com/"
  url "https://ssl.masterpasswordapp.com/mpw-2.6-cli-4-0-gf8043ae1.tar.gz"
  version "2.6-cli-4"
  sha256 "90480c0994cccdaa6637cc311e2092e5b6f2fdc751b58d218a6bd61e4603b2a0"
  head "https://github.com/Lyndir/MasterPassword.git"

  bottle do
    cellar :any
    sha256 "dae1000a0cf67648b022a23f07b9696c45040946118195874aafee9c752a83ec" => :high_sierra
    sha256 "b58efb809596866dba6265a55bcd1be7d59ffa95cd74d3297ea0019badcb911a" => :sierra
    sha256 "b9a997a1c4ba244b904b430e545da399f633bce79464bee3b0153c7707b484cf" => :el_capitan
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
