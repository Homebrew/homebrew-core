class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/v1.2.0.tar.gz"
  sha256 "ae4fd0b5fb7c53e08c3e803b0e81e03d6b1aa3bd982625df8f1e3ef79c5fe760"

  bottle :unneeded

  def install
    bin.install "gimme"
  end

  test do
    system "#{bin}/gimme", "-l"
  end
end
