class Jnv < Formula
  desc "Interactive JSON filter using jq"
  homepage "https://github.com/ynqa/jnv"
  url "https://github.com/ynqa/jnv/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "10304d81f31056a456c00e638ea80ca6506d414b56bb87c8294394de7d31edfb"
  license "MIT"
  head "https://github.com/ynqa/jnv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebd2400a4bc12eeed2e20326f7bc10c772f25d6e1f955de7ff4792de5cb8570e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f8aeb48ada8a345d27ca1dcd3ad833682e27badb3f196506d2ae54fe1253d35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b756b33b93a4a4b5ad212c6e58b984a7b2f53de0acdaf269ca09c498ce29d68d"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcb1fd4466c42c53e5346c6dcbf69c39c3429e9a7048ee23f445c46915c13541"
    sha256 cellar: :any_skip_relocation, ventura:        "d06cba5dc0905ba33a05b2a1bfd2835a8ac6961a4936d192e1843d2e3dca692b"
    sha256 cellar: :any_skip_relocation, monterey:       "c95c5605e8f7c250a03b8aa514d13c97f31780bb705d27009bb754943ccf17f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e500fff8dbdb9bf34c0968ca962846afd173a62aedde23e74a1a926d02054d32"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "llvm" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output(bin/"jnv --version")

    output = pipe_output("#{bin}/jnv 2>&1", "homebrew", 1)
    assert_match "Error: expected value at line 1 column 1", output
  end
end
