class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/cmd/hz/v0.6.6.tar.gz"
  sha256 "ee40bde5d3b25a55dbb8b8c64bd5157939ad9b52056ec753c040757c191c13e5"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  livecheck do
    url :stable
    regex(%r{^cmd/hz/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f01d3302ac00d72d69c4fb420049fec7ab1f3e97acbab082c49a6f058f04fb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f01d3302ac00d72d69c4fb420049fec7ab1f3e97acbab082c49a6f058f04fb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f01d3302ac00d72d69c4fb420049fec7ab1f3e97acbab082c49a6f058f04fb6"
    sha256 cellar: :any_skip_relocation, ventura:        "28dc54f8a5ff7edaf95223b92a7326d46961181291fe57d57f8c5aa4cd8b4da2"
    sha256 cellar: :any_skip_relocation, monterey:       "28dc54f8a5ff7edaf95223b92a7326d46961181291fe57d57f8c5aa4cd8b4da2"
    sha256 cellar: :any_skip_relocation, big_sur:        "28dc54f8a5ff7edaf95223b92a7326d46961181291fe57d57f8c5aa4cd8b4da2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a91802feee185edbd89ff99a66d8bc74e513735a23a92024b1653b57e24d52af"
  end

  depends_on "go" => :build

  def install
    cd "cmd/hz" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
    bin.install_symlink "#{bin}/hz" => "thrift-gen-hertz"
    bin.install_symlink "#{bin}/hz" => "protoc-gen-hertz"
  end

  test do
    output = shell_output("#{bin}/hz --version 2>&1")
    assert_match "hz version v#{version}", output

    system "#{bin}/hz", "new", "--mod=test"
    assert_predicate testpath/"main.go", :exist?
    refute_predicate (testpath/"main.go").size, :zero?
  end
end
