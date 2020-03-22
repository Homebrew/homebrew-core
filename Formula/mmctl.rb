class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      :tag      => "v5.22.0",
      :revision => "cef1dc6a43024d47ffd82140dd27008dd27d8bf3"
  head "https://github.com/mattermost/mmctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4eb25c4d0c51406fa13d207e961e109a122810d3939486691373b184b9de99dc" => :catalina
    sha256 "8713581d42ca4f50c401523025b4f78d13077bcbdb3ac20a77b7e1e2b4f7720e" => :mojave
    sha256 "eb1c359a5892e67b19f5d04999c88ed2603e9d6ddff040663ed814de60fe5723" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath/bin
    ENV["ADVANCED_VET"] = "FALSE"
    ENV["BUILD_HASH"] = Utils.popen_read("git rev-parse HEAD").chomp
    ENV["BUILD_VERSION"] = version.to_s
    (buildpath/"src/github.com/mattermost/mmctl").install buildpath.children
    cd "src/github.com/mattermost/mmctl" do
      system "make", "install"

      # Install the zsh and bash completions
      output = Utils.popen_read("#{bin}/mmctl completion bash")
      (bash_completion/"mmctl").write output
      output = Utils.popen_read("#{bin}/mmctl completion zsh")
      (zsh_completion/"_mmctl").write output
    end
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    assert_no_match /.*No such file or directory.*/, output
    assert_no_match /.*command not found.*/, output
    assert_match /.*mmctl \[command\].*/, output
  end
end
