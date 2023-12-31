class OpenscaCli < Formula
  desc "OpenSCA is a supply-chain security tool for security researchers and developers"
  homepage "https://opensca.xmirror.cn"
  url "https://github.com/XmirrorSecurity/OpenSCA-cli/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "06e8582c1d0ad84ec38a5d0ec6c789f5026b82ed173be8fdbd0959d5a1b52dcc"
  license "Apache-2.0"
  head "https://github.com/XmirrorSecurity/OpenSCA-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd32437e2225a18a073420921c98c59a29f7be2f2a96653a9870f0a54569ef16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5207e068935f7f325b81e21782a205e758ae50d0c1c556149c53f7b092575eae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0aacbb66b6c8761399c78c0db6284334b88bd65b00a6791536326056cf98300"
    sha256 cellar: :any_skip_relocation, sonoma:         "39c34a7be7b68b98a08f8742a8dacbf9ec63feab72d319b5f90a5dacefa66996"
    sha256 cellar: :any_skip_relocation, ventura:        "5698ec87aa459e1726b8ae49a65d426019201cbd34297adb21396cac6214291a"
    sha256 cellar: :any_skip_relocation, monterey:       "751674df11cb77a98a845586f8ac41ebf47a2108df4d776ade2d8c771ac32339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "185234379a727461872ee8d31d43c5bace0176717f103d039a70e2d4b6505ab1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X 'main.version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"opensca-cli", "-path", testpath
    assert_predicate testpath/"opensca.log", :exist?
    assert_match version.to_s, shell_output(bin/"opensca-cli -version")
  end
end
