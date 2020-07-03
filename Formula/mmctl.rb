class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      :tag      => "v5.25.0",
      :revision => "c81bdf8d687f76c5da0205f8f612dc7f48969ca0"
  head "https://github.com/mattermost/mmctl.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcaa45d467dfe23b1416194abf9f925a2d0ba8f964ede6a9a5f3158e321261e8" => :catalina
    sha256 "b26a63c5ff5f6b4c77cbfd9e8ea19b7891db87a3181771191062bb53a66e8286" => :mojave
    sha256 "e7336db2804579040d3fb43e2afeecb1bcd3e4f500b7d3fe47a98612d96ffbde" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath/bin
    ENV["ADVANCED_VET"] = "FALSE"
    ENV["BUILD_HASH"] = Utils.safe_popen_read("git rev-parse HEAD").chomp
    ENV["BUILD_VERSION"] = version.to_s
    (buildpath/"src/github.com/mattermost/mmctl").install buildpath.children
    cd "src/github.com/mattermost/mmctl" do
      system "make", "install"

      # Install the zsh and bash completions
      output = Utils.safe_popen_read("#{bin}/mmctl completion bash")
      (bash_completion/"mmctl").write output
      output = Utils.safe_popen_read("#{bin}/mmctl completion zsh")
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
