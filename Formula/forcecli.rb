class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v1.0.1.tar.gz"
  sha256 "3e3e4e3ac333813055e1f4423386917cd065d2f258359c876428232f2fb2bcb3"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e22d5a2ce2eee0377fa261439d4898e3f96e188fd078b1a08dd427639951262e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e22d5a2ce2eee0377fa261439d4898e3f96e188fd078b1a08dd427639951262e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e22d5a2ce2eee0377fa261439d4898e3f96e188fd078b1a08dd427639951262e"
    sha256 cellar: :any_skip_relocation, ventura:        "99b1077a3dda16e004bd228fb749a67b1dfc3b6a81b135f7f5efa6be6fbcb1ce"
    sha256 cellar: :any_skip_relocation, monterey:       "99b1077a3dda16e004bd228fb749a67b1dfc3b6a81b135f7f5efa6be6fbcb1ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "99b1077a3dda16e004bd228fb749a67b1dfc3b6a81b135f7f5efa6be6fbcb1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5135b4c95211fef97835e275d02a653023de57b787249325ee82039c9e4c7386"
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
