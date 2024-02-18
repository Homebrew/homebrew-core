class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.9.10.tar.gz"
  sha256 "99a013e23b58d39fa729e0387535133aa64df6f5c23d42a3d3d407c55abe47c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb333ef7f3baf91af500cae1fa4fe3cefe623d9138466b6ef29af105061856de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4ae822ae2175cd271948992b08e5165bc85ff1c110dbf0438abac99b189d0359"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed9d43cb0294fe2b2e6701e2136471cfaf811ac7bf53c778e26589bab1950655"
    sha256 cellar: :any_skip_relocation, sonoma:         "58c7202a58925ef47836d453c57362978bde0422589afa329b50f34413630bcf"
    sha256 cellar: :any_skip_relocation, ventura:        "50c58e7c987a88944bebd5fe5084f07118df0c2882dc42ce386ea5753dcba89f"
    sha256 cellar: :any_skip_relocation, monterey:       "b7c80e71fb07380fbdf78cf3d20a622a08c4354ddbd13848556433dea8372684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1577ef16c81bcb2b1cd9188e20757ece02f37a12646aa8be75c15b439c0512de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
