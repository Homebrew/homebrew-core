class GitOpen < Formula
  desc "Open GitHub webpages from a terminal"
  homepage "https://github.com/jeffreyiacono/git-open"
  url "https://github.com/jeffreyiacono/git-open/archive/v1.3.tar.gz"
  sha256 "a1217e9b0a76382a96afd33ecbacad723528ec1116381c22a17cc7458de23701"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "git-open.sh" => "git-open"
  end

  test do
    system "#{bin}/git-open", "-v"
  end
end
