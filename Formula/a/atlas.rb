class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "33fc874bd5c155f7d1a88a36efd0a431bc4eaa41ca0602684bc7259538453f60"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "87fb3d5ec9c643f9bb31071cc2aa807b8ba0dd7b54cd54f008e12af2d2cf475d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45a2b91bd5208e5e1891e7840a18fe0ee750bf1a02f32e43cb0863e035c67859"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1bbc3c01d816a8373b2d2cefa56afecd648a20933239e5e84b0faccfe1f6515"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed7fb079f26570a68204e7dcb96f89f6ef016895af6c2e63ee46ddcf5338478a"
    sha256 cellar: :any_skip_relocation, ventura:        "570db28399471ce2b2b94dae396ead23e774f8bccf109d242365f79a6ffa86c0"
    sha256 cellar: :any_skip_relocation, monterey:       "90dfd26a8c7ef2c0ad0e62da15edc4f18b1b27145d1090b28990d0022e1b2300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d67e2ff7fb067b38b58bf1b0e8daece69c883da51c7542a4d91ebe84633c833"
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
