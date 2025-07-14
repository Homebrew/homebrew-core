class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "801628efffed39f678a9d2e4023303209c4b3f22c7f1b3049573270aa7ce6980"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6fe12934df5e20c4bac8af947954b4df1e9576a4dff35e6f775351865a08950"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6fe12934df5e20c4bac8af947954b4df1e9576a4dff35e6f775351865a08950"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6fe12934df5e20c4bac8af947954b4df1e9576a4dff35e6f775351865a08950"
    sha256 cellar: :any_skip_relocation, sonoma:        "4810b10e457a78fea9a912d0243dc3745a1cad0c02c4ca7f1bce06fdede89d22"
    sha256 cellar: :any_skip_relocation, ventura:       "4810b10e457a78fea9a912d0243dc3745a1cad0c02c4ca7f1bce06fdede89d22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96aed7f9594e762579ad43d6580f9241564005cd19e15143cfb3f50b5c154364"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", "completion")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
