class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "64e3a0538a3d98a275b1e22c9d8d8a14d13ee53cb6aa5731d26842d4ec6bc29b"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9b0d3e3937e9396e7926cd831b26117963622fcb81b42369aad039c4c79d34b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a5c1d2859f3309eeed4ed51119717056db207cdf6d30af74a58d107fab836ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a5c1d2859f3309eeed4ed51119717056db207cdf6d30af74a58d107fab836ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a5c1d2859f3309eeed4ed51119717056db207cdf6d30af74a58d107fab836ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd4f167e63fc13ce822979955a4f07ef09c3d31780637d26058b599a403d873a"
    sha256 cellar: :any_skip_relocation, ventura:       "dd4f167e63fc13ce822979955a4f07ef09c3d31780637d26058b599a403d873a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bac13a5d07333186dea8557a8779e6fe7b9c3fec0bf62aa883cdc491ae40f2a7"
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
