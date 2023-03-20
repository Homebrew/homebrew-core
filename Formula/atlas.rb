class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.10.0.tar.gz"
  sha256 "d7366ec0322c6edb40cd567700b442b6ba7f48df59cf43c4f5f6ce6635f1f341"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "534302a7c50e3aea436a661b7a5340160071e352f5698ad40d78efc61988ed78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4deb528296c40c9fc60d8addbec71a8baa981dbe24a2491ae73288af1ae011d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73d1a1f609417ab4103eca8473021bee987b2ca8e719eb198d45f58d071d6fad"
    sha256 cellar: :any_skip_relocation, ventura:        "aafed38b9d4ac27768f579760a134f54ff23fac819a24b59b13e5ebb793fef41"
    sha256 cellar: :any_skip_relocation, monterey:       "3ee70473e4be13d5db97cf1d12546a113b498690ed88eed4a74ad6caffaa9c45"
    sha256 cellar: :any_skip_relocation, big_sur:        "b32818cd7d9c4c8357cb7c9c9413875b8d0834f9e6e3b1614cda2befef6d373f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c70006afd7707935e4ec3ce1ce350ed2950db0125abe31e9ea1d80d61003a15"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
