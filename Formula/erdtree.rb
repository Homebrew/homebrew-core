class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://github.com/solidiquis/erdtree/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "1c794f96296e261d4f564947a4b2e2f8689f7c2d81f0163ecc149f1261885f93"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4535c1e232da054cd41dc3cc1d31b7fae8d0cf6ae584bd47a9db1d2c6ce0c7b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97199abe0eae43a0ab4a407bfbe132cd033d4abd56b9183c889bb81e88f89106"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e365be8cc385fd155382a01b141f3b3605936f25b4561efc43d34959d90906b3"
    sha256 cellar: :any_skip_relocation, ventura:        "323cf8beacff214f2088756dde28818ee3920c4fd9ba76d413c1730cf42b4fb7"
    sha256 cellar: :any_skip_relocation, monterey:       "9b60d188089f6c9ffd826635e0381a9e578872df3a6eefebfc3a13bbfd00909e"
    sha256 cellar: :any_skip_relocation, big_sur:        "94a799bacc0c9c4fab01b9c979b78fba8b8e0c831894203534034fb4fa37f290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1469dc85534a7dc2232082189eebd4f500dea081dad79609d85a891d61db6a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/et")
  end
end
