class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/v1.5.4.tar.gz"
  sha256 "71036f892b3cae08f29be6fd4c69fb20d9b003ec80a24221d73e995e12ab0fe0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "955a907946bda06e3e0eeef3af936182915ddfae8040eb744a394a47a570e9d0"
  end

  def install
    bin.install "gimme"
  end

  test do
    system "#{bin}/gimme", "-l"
  end
end
