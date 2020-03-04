class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.27.1.tar.gz"
  sha256 "8009e57788dd7fe528d8e41b8fafc1d209b8d02119f4556b6921f1b665c1e285"
  head "https://github.com/ForceCLI/force.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5269c8ab9fccba75efe3f822abe3d41a9dd59769ed3eab204f875730ad72ee35" => :catalina
    sha256 "37fb8cbf2d4824cb5e5d6d7a25c2403ca10eeadeb2a71f6c593698748349bb98" => :mojave
    sha256 "19ee5f0d7a3a08734303fc565ce2a42b10e71eb8aaf7cdaa8735fdaef711ac4f" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
