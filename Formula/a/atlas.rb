class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "410696021a098bb949c3d91f89df295bd8cc98fa7f51c43a8a4c959f6e9fe7c3"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04893393ec7fad6f9ad08f6bb2a5c9bb07311376eb07a9e625607f65d44f877f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3a9af449d66e054f2cf1c3831337f933d4f27596e47bea47e1fd26cb01ba3ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54ca46a5d0976999b1bd82702317c8f6862cf6d18cab5586508da6bcdbb56ed4"
    sha256 cellar: :any_skip_relocation, sonoma:         "54340dd8b5b38645daf1abce56b0399c17edea26ee2f38ea4d4caf5d0cb95056"
    sha256 cellar: :any_skip_relocation, ventura:        "d8ec662a8edca302b43578c17ba9c3bc57987081b0c1e1d63d21371637990e04"
    sha256 cellar: :any_skip_relocation, monterey:       "34cd8e47af8ffbd3f0af89e229ae5e50aa8a3a95d6d8cc6862ed90a069c34167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d838d73dfda76627afe7c749cd322f76668193f598a3860a58f4fc61f01ed390"
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
