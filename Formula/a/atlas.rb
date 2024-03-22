class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "4e373b9b79c945aefc5552f1925510479d16ba9f7ca84348b3dc1962505c6f73"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8cbb58f4595abd9255280f13c839e8250449c3d87feecd1fc37ce79c55e2ef63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fad13cc08b7ac8da802c9653db44706d27d348ba84db7050a5fc3c2c6bbcb1ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fea3afce4fc4056f37ab31271e8c80ce6881b0ce0702a1e98f0682e69befef6"
    sha256 cellar: :any_skip_relocation, sonoma:         "867d6d75f9e36f0ec3cbd699caf314131ad3e58670a4f6be357d62f1932fff4d"
    sha256 cellar: :any_skip_relocation, ventura:        "9ef4f30f8fa7d977e0567b17bb88e69a2d783b9b167c8495f17a945e1ab33b89"
    sha256 cellar: :any_skip_relocation, monterey:       "f8258cd7b60b854d04d24760d5512fe6df11543a6f5056b1d88c9dbce3e7b040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a70a1541c55d3f7557f8ed794405912af8139feb74ba51b009c8a918cc774f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
