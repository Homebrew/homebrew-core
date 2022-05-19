class Hof < Formula
  desc "Flexible data modeling & code generation system"
  homepage "https://docs.hofstadter.io/"
  url "https://github.com/hofstadter-io/hof.git",
      tag:      "v0.6.2-beta.1",
      revision: "cdaa1bc1c6f8e0c432688376d47b470de9606e4b"
  license "BSD-3-Clause"
  head "https://github.com/hofstadter-io/hof.git", branch: "_dev"

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    ldflags = %W[
      -s -w
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.Version=#{version}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.Commit=#{Utils.git_head}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.BuildDate=#{time.iso8601}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.GoVersion=#{Formula["go"].version}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.BuildOS=#{os}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.BuildArch=#{arch}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hof"

    bash_output = Utils.safe_popen_read(bin/"hof", "completion", "bash")
    (bash_completion/"hof").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"hof", "completion", "zsh")
    (zsh_completion/"_hof").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"hof", "completion", "fish")
    (fish_completion/"hof.fish").write fish_output
  end

  test do
    system bin/"hof", "mod", "init", "cue", "brew.sh/brewtest"
    assert_predicate testpath/"cue.mods", :exist?
    assert_equal "module: \"brew.sh/brewtest\"", (testpath/"cue.mod/module.cue").read.chomp

    assert_match version.to_s, shell_output(bin/"hof version")
  end
end
