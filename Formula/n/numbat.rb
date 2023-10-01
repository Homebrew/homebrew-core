class Numbat < Formula
  desc "Statically typed programming language for scientific computations"
  homepage "https://github.com/sharkdp/numbat"
  url "https://github.com/sharkdp/numbat/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "62400366887ad2f52a0de3d9f47cb17606566a3ca238aa496402c1538d507566"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sharkdp/numbat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64fd40fb929b480bd013e5b60f24355161ea9b32b8bc4823980f1af3bd6e00d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb2eba59e3cfdcff0a62de2782c9f972a963eaf196dc2b4009dbca9d2d9f4513"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe2146028ae6ee9292d721a565bda5ae01bae688e5a1d24e9215e789d977e7a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c430a90f41d1446b7d9f09120057ccbbf813d20156e19414e2c624b448be5afe"
    sha256 cellar: :any_skip_relocation, sonoma:         "01146aafeb40058f8f89f2f9cd9a6dedd47b39ecc147cacd0da050c36dea36c1"
    sha256 cellar: :any_skip_relocation, ventura:        "e45dbd22b43f999cfc78663efb8517b34e5a552d3f8bfa47d01d0259cc76ab40"
    sha256 cellar: :any_skip_relocation, monterey:       "488d06bd0450f60bf64e0a8242a158f7e748651d5f75675694b40f978ad5701f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffd34826b5aa205dd9a91d8250223c284381db52e0f638b55bca2fc34c2ef079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dec542e5b5b473b3c9e59cf4901e416c07ce836172b97826118246331872065"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "numbat-cli")
  end

  test do
    (testpath/"test.nbt").write <<~EOS
      print("pi = {pi}")
    EOS

    output = shell_output("#{bin}/numbat test.nbt")

    assert_equal "pi = 3.14159", output.chomp
  end
end
