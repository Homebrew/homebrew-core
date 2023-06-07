class Hof < Formula
  desc "Flexible data modeling & code generation system"
  homepage "https://hofstadter.io/"
  url "https://github.com/hofstadter-io/hof.git",
      tag:      "v0.6.7",
      revision: "5f6770b9628cd46a4caa24594e052dd715ac2dca"
  license "BSD-3-Clause"
  head "https://github.com/hofstadter-io/hof.git", branch: "_dev"

  # Latest release tag contains `-beta`, which is not ideal
  # adding a livecheck block to check the stable release
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "201fc39b5bfa2a144cf714cd8c974ab4d7c40bc73fe3c0ffb880f2d910759463"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "201fc39b5bfa2a144cf714cd8c974ab4d7c40bc73fe3c0ffb880f2d910759463"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "201fc39b5bfa2a144cf714cd8c974ab4d7c40bc73fe3c0ffb880f2d910759463"
    sha256 cellar: :any_skip_relocation, ventura:        "682e97ef134c35fae44303613bf5153d778c043ce4bd82269f9d5c53a9348e2f"
    sha256 cellar: :any_skip_relocation, monterey:       "17049cc5cb7f04eebe8de0ec4353c77df7cf04466b91ab84fe982f0b8b7cd7e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "17049cc5cb7f04eebe8de0ec4353c77df7cf04466b91ab84fe982f0b8b7cd7e2"
    sha256 cellar: :any_skip_relocation, catalina:       "17049cc5cb7f04eebe8de0ec4353c77df7cf04466b91ab84fe982f0b8b7cd7e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "222943c19066f222fefcd9530b28f0024e74bea67395ecb57107bf9d11451754"
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
