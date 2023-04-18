class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.99.4.tar.gz"
  sha256 "8439143f865b9baf8b5d073be5ff68d67e11873dc5edf50541525c14dd28a543"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "241af37aa6b61cd2003a1cb90dfc1e69b9d0058e0f02daeb88230abab74dc997"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f2946b4428c3c9de54152f023d3c35ba297e1ed65970a5161209d6f17c5cd89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e265631fa2aedf954e16b608a0b092536f0f01b4a3a1d9b5af87c59c215c6423"
    sha256 cellar: :any_skip_relocation, ventura:        "2e187753bafd63a018a62b3c97499395a34b10af8924c335613f24f38d1a543d"
    sha256 cellar: :any_skip_relocation, monterey:       "9c673f97165c2a21ec0286d3a41d7f79d5667d1b9917b1a9af7949fa8cd68f65"
    sha256 cellar: :any_skip_relocation, big_sur:        "47522f113b88826dbef5cc05486994e2028393213f16a920c274f28b2403ceb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49857724f89d31e790246097ffc8d249ca4eadf0a65c5b47a13d154780ef12e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"force")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
