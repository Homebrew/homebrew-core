class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      :tag      => "v5.20",
      :revision => "e24eda30a4dc4048790a84ff7614c9bc4e982c69"
  head "https://github.com/mattermost/mmctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "044c2188813a4bc19f805f0d1bcf94f43cc622031b80e20393246136163c5a8d" => :catalina
    sha256 "b712c23311199bc8ec0a7dcf242844c2eaa38fd8e1919f76f38b7ce6312fa869" => :mojave
    sha256 "ef52e7801b8a906d182010aa04a134bac57627d0594049c067f759a98ef82b14" => :high_sierra
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
