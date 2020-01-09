class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      :tag      => "0.2.1",
      :revision => "c330b36f679b69ac33fa1e561190ad2eb3466777"
  head "https://github.com/mattermost/mmctl.git"

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
