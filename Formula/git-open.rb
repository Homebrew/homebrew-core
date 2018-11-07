class GitOpen < Formula
  desc "Open GitHub webpages from a terminal"
  homepage "https://github.com/jeffreyiacono/git-open"
  url "https://github.com/jeffreyiacono/git-open/archive/v1.2.tar.gz"
  sha256 "4bc50a5fa019e8306c93deb46b284f1883ab4fc5de88770d7d89755dcf8e0a5d"

  bottle :unneeded

  def install
    bin.install "git-open.sh" => "git-open"
  end

  test do
    system "#{bin}/git-open", "-v"
  end
end
