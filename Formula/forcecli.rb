class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.27.1.tar.gz"
  sha256 "8009e57788dd7fe528d8e41b8fafc1d209b8d02119f4556b6921f1b665c1e285"
  head "https://github.com/ForceCLI/force.git"

  depends_on "go" => :build

  def install
    # Don't set GOPATH because we want to build using go modules to
    # ensure our dependencies are the ones specified in `go.mod`.
    mkdir_p buildpath
    ln_sf buildpath, buildpath/"force-cli"

    cd "force-cli" do
      system "go", "build", "-o", bin/"force", "main.go"
    end
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
