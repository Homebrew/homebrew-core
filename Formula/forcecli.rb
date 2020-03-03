class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.27.1.tar.gz"
  sha256 "8009e57788dd7fe528d8e41b8fafc1d209b8d02119f4556b6921f1b665c1e285"
  head "https://github.com/ForceCLI/force.git"

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
