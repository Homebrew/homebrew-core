class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://masterpasswordapp.com/"
  url "https://masterpasswordapp.com/mpw-2.6-cli-5-0-g344771db.tar.gz"
  version "2.6-cli-5"
  sha256 "954c07b1713ecc2b30a07bead9c11e6204dd774ca67b5bdf7d2d6ad1c4eec170"
  revision 1
  head "https://github.com/Lyndir/MasterPassword.git"

  bottle do
    cellar :any
    sha256 "8c63ff8456087dc2476df24055a58dfc6f8eb79f84c611f963ef1964fa13819b" => :mojave
    sha256 "46677cf8649983d5b77103d2ca56d9ad3697808ecc406f626a3462a089f932da" => :high_sierra
    sha256 "19bf22915b3c534ad3ee6f1dfc20f142d53ae6c0c88757ae2632b7b1daa6667f" => :sierra
    sha256 "7090c3d31289d2ac5529bd0a6bae2632a36ba7fcd4bb7974248bb36a15f67c7e" => :el_capitan
  end

  depends_on "json-c"
  depends_on "libsodium"
  depends_on "ncurses"

  def install
    cd "platform-independent/cli-c" if build.head?

    ENV["targets"] = "mpw"
    ENV["mpw_json"] = "1"
    ENV["mpw_color"] = "1"

    system "./build"
    system "./mpw-cli-tests"
    bin.install "mpw"
  end

  test do
    assert_equal "Jejr5[RepuSosp",
      shell_output("#{bin}/mpw -q -Fnone -u 'Robert Lee Mitchell' -M 'banana colored duckling' -tlong -c1 -a3 'masterpasswordapp.com'").strip
  end
end
