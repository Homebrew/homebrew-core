class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "dc046226a786f0158779c8f19fe09049d322683d3120a1abf0df6886a58ed21e"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db6f02bea458d873fca4d97be0436e04a702718f3f09df423b44959363319395"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db6f02bea458d873fca4d97be0436e04a702718f3f09df423b44959363319395"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db6f02bea458d873fca4d97be0436e04a702718f3f09df423b44959363319395"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f44901019df1beb58eccbce720922929adc6c093b66117ac74f26cab4dc9038"
    sha256 cellar: :any_skip_relocation, ventura:       "8f44901019df1beb58eccbce720922929adc6c093b66117ac74f26cab4dc9038"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e04a095a9ff320119252ba7a50b8a6a0e14de191ae3737288eb168867f6aabcd"
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
