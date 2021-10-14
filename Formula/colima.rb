class Colima < Formula
  desc "Container runtimes on MacOS with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.2.1",
      revision: "28236769c47ab71dd378d56f6cc73f769fd2f503"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  depends_on "go" => :build
  depends_on "lima"

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/colima"

    ["bash", "zsh", "fish"].each do |shell|
      (buildpath/"colima.#{shell}").write Utils.safe_popen_read(bin/"colima", "completion", shell)
    end
    bash_completion.install buildpath/"colima.bash" => "colima"
    zsh_completion.install buildpath/"colima.zsh" => "_colima"
    zsh_completion.install buildpath/"colima.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end
