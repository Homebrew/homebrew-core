class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "e500c88c4bcabe853d596c576ac44d5985ba265c4ef431d93299d8349b3f98e0"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "27fe7f3927462b16722699796630c031660bfb62c4e6008ab504de09b6cee428"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2dcb7bad2e24674c36732f0f9726835b5d07d2b9ea6c39aa515983f7a12da011"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae6c9465237663b58b6efd8100fa01decc5fd3a24f1103f64f5a7e8eafd6cc79"
    sha256 cellar: :any_skip_relocation, sonoma:        "e82d45a0a5c43687ce24ab5de571fb60e5037c29200c9b45205d96991a148c0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e1f48f0a3e0551efc69eb3895da8eaa6a5a247c2e5e32d4ecd6c25ee1657890"
    sha256 cellar: :any,                 x86_64_linux:  "dfd854b1126063f1c0ded25fe1006f5d003a83502374050071fcf52e28ea5fea"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
