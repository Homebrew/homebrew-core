class Gimme < Formula
  desc "Shell script to install any Go version"
  homepage "https://github.com/travis-ci/gimme"
  url "https://github.com/travis-ci/gimme/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "50c42ec01505bee0e5b60165a0f577fe1e08fe9278fe3fe4b073c521f781c61e"
  license "MIT"

  bottle do
    manifest_sha256 "108c186910ea4f6c65757a9a4f7488022273dd58917df9dd241275a847de3fb9"
    sha256 cellar: :any_skip_relocation, all: "a8ec70ee55a17b2a5ba037a519eab2618dc5ccd3c6198d28f2ec64065639896c"
  end

  def install
    bin.install "gimme"
  end

  test do
    system bin/"gimme", "-l"
  end
end
