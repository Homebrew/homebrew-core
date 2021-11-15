class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/v1.0.6.tar.gz"
  sha256 "ef0ade0508f0d6d8ed7e80f06e2ed888eaca9837fde513fc801451044b6a567e"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98aa3d8b0c4f290f1c49ddd6a2494402e131a5d80a7a5b6121578d45ffb2a97c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7649cd5bd8bc64650deb59d632bbb41dc4019ec0b274429e91c528f867b1657"
    sha256 cellar: :any_skip_relocation, monterey:       "02f2786ef09886d28d569d47c962257efe7f54b68b4217166cf9b2aa96018ac4"
    sha256 cellar: :any_skip_relocation, big_sur:        "86d7ea41fa000eec1131088f2bc587b59cafebdfcf5a69bf9de6bc08cedf4428"
    sha256 cellar: :any_skip_relocation, catalina:       "849ac2af9f0c7243ede6c4eff3c48940b5481308eea710a421a2b78b9227e9f2"
    sha256 cellar: :any_skip_relocation, mojave:         "65d790cbb774b8bd2ff2b4ca18125754ebc3d340ad233a2076902e6465e2bc2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b87827d4c15c1f99f9792af793ef87c63aaa47756ea8362d1fc57b7ea028ad"
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
