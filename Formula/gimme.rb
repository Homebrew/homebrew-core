class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/v1.5.1.tar.gz"
  sha256 "1e718f08f1e73dd9dbd21304a69a1a5d10c462f8c67ac40da1e1fd31077215a8"

  bottle :unneeded

  def install
    bin.install "gimme"
  end

  test do
    system "#{bin}/gimme", "-l"
  end
end
