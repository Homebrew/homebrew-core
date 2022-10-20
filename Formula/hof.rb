class Hof < Formula
  desc "Flexible data modeling & code generation system"
  homepage "https://hofstadter.io/"
  url "https://github.com/hofstadter-io/hof.git",
      tag:      "v0.6.6",
      revision: "0f49b4d71a66788b006daacf905a2b138768beca"
  license "BSD-3-Clause"
  head "https://github.com/hofstadter-io/hof.git", branch: "_dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75ab35b3306aae9403b60288ac6e3f53dc8fb2a56a1a6d92643b9c4872ec1a79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75ab35b3306aae9403b60288ac6e3f53dc8fb2a56a1a6d92643b9c4872ec1a79"
    sha256 cellar: :any_skip_relocation, monterey:       "4a19dd456fd4d394eef9c77af87ba4511f8af94b44f6f5d78e7cbe498e3e9ffa"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a19dd456fd4d394eef9c77af87ba4511f8af94b44f6f5d78e7cbe498e3e9ffa"
    sha256 cellar: :any_skip_relocation, catalina:       "4a19dd456fd4d394eef9c77af87ba4511f8af94b44f6f5d78e7cbe498e3e9ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79bac705d5a07de8f182b4d6ed0035683c852681296491a4a68a84d6b88d3fb0"
  end

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

    ENV["CGO_ENABLED"] = "0"
    ENV["HOF_TELEMETRY_DISABLED"] = "1"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hof"

    generate_completions_from_executable(bin/"hof", "completion")
  end

  test do
    ENV["HOF_TELEMETRY_DISABLED"] = "1"
    assert_match "v#{version}", shell_output("#{bin}/hof version")

    system bin/"hof", "mod", "init", "cue", "brew.sh/brewtest"
    assert_predicate testpath/"cue.mods", :exist?
    assert_equal "module: \"brew.sh/brewtest\"", (testpath/"cue.mod/module.cue").read.chomp
  end
end
