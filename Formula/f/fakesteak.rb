class Fakesteak < Formula
  desc "ASCII Matrix-like steak demo"
  homepage "https://github.com/domsson/fakesteak"
  url "https://github.com/domsson/fakesteak/archive/refs/tags/v0.2.4.tar.gz"
  sha256 "0f183a2727e84d2e128e3192d4cff3e180393c9c39b598fa1c4bfe8c70a4eb1a"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db338e1df1d6d6a935d23eaf2504754d52ae853e34dcd6a67e946fba16ab440c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "509606cd242afeeabce6a61fb81907e05fa8b0104522e2278fa63d221f42621a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2db316e9435541f9be26b69120e29c9c56b588618d01fc19a0c5daded7db8f86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce939e2b91c0f63e2f29534fce23306a266b9a08569aa73608973f82d963507d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2f86a907d30ec94ef32e5f60e91bfb1c938c3283144ce5d0ecd9844b53ff2f2"
    sha256 cellar: :any_skip_relocation, ventura:       "7f80849b67d39baee17d87603098b7d6ecc480d2b67108f2b311d91c874394a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74164e3c8e1eaf53327943ef1e0e454ab02695e54fbd440e4ca247aaffc79663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aebc761ec7d4c947ef5cc769fd00c3cb00d3b02ad42ff1395ccdddf6d685da18"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakesteak -V")
    assert_match "Failed to determine terminal size", shell_output("#{bin}/fakesteak -s 1 2>&1", 1)
  end
end
