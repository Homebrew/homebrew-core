class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/refs/tags/v3.5.2.tar.gz"
  sha256 "df8d71ae46a0c9a29e68ced233fdc3a73f4068b9098e7c6b5bc4679019ffe1d9"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6fa8936560f72fb97eb2eacd801c1e4425f07976cf1dc9adc677c539a46595fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7d5089779ae230ae95e2903325d017f9d3b43d46fa52f44b973edcad113ef6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7d5089779ae230ae95e2903325d017f9d3b43d46fa52f44b973edcad113ef6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7d5089779ae230ae95e2903325d017f9d3b43d46fa52f44b973edcad113ef6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae8cbe12b22ffa4fea1b26c66331a91bf373e61d150d2d09cf5e43c7d3c69279"
    sha256 cellar: :any_skip_relocation, ventura:        "ae8cbe12b22ffa4fea1b26c66331a91bf373e61d150d2d09cf5e43c7d3c69279"
    sha256 cellar: :any_skip_relocation, monterey:       "ae8cbe12b22ffa4fea1b26c66331a91bf373e61d150d2d09cf5e43c7d3c69279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7d5089779ae230ae95e2903325d017f9d3b43d46fa52f44b973edcad113ef6c"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
