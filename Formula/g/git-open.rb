class GitOpen < Formula
  desc "Open GitHub webpages from a terminal"
  homepage "https://github.com/jeffreyiacono/git-open"
  url "https://github.com/jeffreyiacono/git-open/archive/refs/tags/v1.3.tar.gz"
  sha256 "a1217e9b0a76382a96afd33ecbacad723528ec1116381c22a17cc7458de23701"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "142aaeed12d42b049c0414d59f19f8dfddf1c1c83dee8f208b1af1e745fd432d"
  end

  def install
    bin.install "git-open.sh" => "git-open"
  end

  test do
    system bin/"git-open", "-v"
  end
end
