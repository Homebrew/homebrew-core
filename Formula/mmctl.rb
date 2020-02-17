class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      :tag      => "v5.21",
      :revision => "59b311f3b6e8a0f7408b5b84f08c6317c9611135"
  head "https://github.com/mattermost/mmctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0221eb71e054ca73e69e3379456fc13cc9925a789c5166f942cb0f557a90a529" => :catalina
    sha256 "60a19274ae83adfbb9215033cd2ef4f88fd24d7d779b152d98a22e9cb311c17f" => :mojave
    sha256 "d68259149975cdc80fe24cc2354df4eefbe6dfbb94c9631977bed9d6254a3345" => :high_sierra
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
