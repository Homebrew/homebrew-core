class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/v1.5.5.tar.gz"
  sha256 "7854c3f90c2274e14041138f53c9c0bf671be86e49dfb4a61b024270a514fb40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd677d17e7c2316bce3c567ce9cc708b2c3e6bf57ed867f64554e202b7b78746"
  end

  def install
    bin.install "gimme"
  end

  test do
    system "#{bin}/gimme", "-l"
  end
end
