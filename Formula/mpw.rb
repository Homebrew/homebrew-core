class Mpw < Formula
  desc "Stateless/deterministic password and identity manager"
  homepage "https://masterpassword.app/"
  url "https://masterpassword.app/mpw-2.7-cli-1-0-gd5959582.tar.gz"
  version "2.7-cli-1"
  sha256 "480206dfaad5d5a7d71fba235f1f3d9041e70b02a8c1d3dda8ecba1da39d3e96"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.com/MasterPassword/MasterPassword.git"

  # The first-party site doesn't seem to list version information, so it's
  # necessary to check the tags from the `head` repository instead.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+[._-]cli[._-]?\d+)$/i)
  end

  bottle do
    cellar :any
  end

  depends_on "jq" => :build
  depends_on "json-c"
  depends_on "libsodium"
  depends_on "ncurses"

  def install
    cd "cli" unless build.head?
    cd "platform-independent/c/cli" if build.head?

    ENV["targets"] = "mpw mpw-tests"
    ENV["mpw_json"] = "1"
    ENV["mpw_color"] = "1"

    system "./build"
    system "./mpw-tests"
    system "./mpw-cli-tests"
    bin.install "mpw"
  end

  test do
    assert_equal "Jejr5[RepuSosp",
      shell_output("#{bin}/mpw -q -Fnone -u 'Robert Lee Mitchell' -M 'banana colored duckling' " \
                   "-tlong -c1 -a3 'masterpasswordapp.com'").strip
  end
end
