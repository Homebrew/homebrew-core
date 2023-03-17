class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.1.3.tar.gz"
  sha256 "0b050f1b0754e49f531f29878728611627626dcb5c5ad86abbc3135b4a0a3193"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b4cbab6ae81471f9007a57cc7873a9ae577809bd7f0cc975f166a4b4cbad22b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81d3f5929ecb1de646595fee25e7df34fc4640787cbd272dd6716030cddbe50b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07169046171554c890f2cd35d35b951fcb3caa00e0c98d28e3ed90fd9691e361"
    sha256 cellar: :any_skip_relocation, ventura:        "ec476741d690e6feac32d6211552da2f5d38fc6d9670fac6a9d3a7ff9f62d3a0"
    sha256 cellar: :any_skip_relocation, monterey:       "e5d534ef4b81f122e210fc7ff29da42da266ac09cfa70e5efbdebc4e5d86452d"
    sha256 cellar: :any_skip_relocation, big_sur:        "683efed8cab1c6720b43c5af0505ed9b8a83fae4cb684d2c44fe31e90242b8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db00227996310a004fa8d2c20bb41fafc4b00a3a831da537b463df64eb505ffe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
