class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4-client/archive/refs/tags/v4.7.6.tar.gz"
  sha256 "fa27df0a26ec196a3f65f64aa7b33b2f2e2a086044528109b5a7d82fa66be062"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4-client.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ee5e24a4383a826a15a1d394fe905e7e66ded733417ba08dd9dc58310cf419a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc75e20687b7d2494ecbfe31f2b0ba8e3e87dc96ad309e9a6d2b55c15cb95337"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83bf5bb6aec991cadba319169645efb964ae039736a1afecc14620dd79d8110a"
    sha256 cellar: :any_skip_relocation, ventura:        "9f2a06a62e6c3d50996a1c5e2ea2a888a396ffa5036a2df765d2d2e612feb6e5"
    sha256 cellar: :any_skip_relocation, monterey:       "b1e4d11282b4a7c42723f1d11c86353d5e120ca4be454dd526533e6691f7c493"
    sha256 cellar: :any_skip_relocation, big_sur:        "d11eb7af9d82a9f857ed1161b1e366091fed4fb264f2f694b11ff1643cd3ffdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ff0fd879061c0b805686330c5c793355436098bf20a318129d8e3fcbfcff872"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Error: invalid username or password",
     shell_output("#{bin}/geph4-client sync --credential-cache ~/test.db 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/geph4-client --version")
  end
end
