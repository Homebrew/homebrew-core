class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/v1.0.0.tar.gz"
  sha256 "0e9342433284b8b7cfdf5587e226fd2da5123e54bec37114fdde365db28b6911"

  bottle :unneeded

  def install
    bin.install "gimme"
  end

  test do
    system "#{bin}/gimme", "-l"
  end
end
