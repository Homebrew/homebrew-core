class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.99.3.tar.gz"
  sha256 "4aeb530f4510b421b2d769e8e2f5b581f5e4613c5f58ec1e68273c2fa6f25d90"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83629e442ad44a4b286f3c323e562adcd845e0de85cad6d9360cea61ea3d5610"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6de14a4d594a25cf9de9736ae0a648beceb5cc28a5a6a20ba0283a4885a6abeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad57d3ecb79c1cebd469ce71fb84ef1309ece79c145f5d158e25a553b75b2140"
    sha256 cellar: :any_skip_relocation, monterey:       "43b5c07fcf2acf2755b9803998d4601c2945641fba850d509827007d16c62263"
    sha256 cellar: :any_skip_relocation, big_sur:        "999673ddf79fde79cb559181fbec13e8d67bf76fc0e678f01607c9066992a562"
    sha256 cellar: :any_skip_relocation, catalina:       "8cd3aef35fb79ab653eed7c48b6ea93900620194149906a620bc56eee6c522b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0819b1a5223e3a98b0d0d7d05e7aeb1b9a6aeccd15957944bb577ed1435cd3a"
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
