class Hof < Formula
  desc "Flexible data modeling & code generation system"
  homepage "https://hofstadter.io/"
  url "https://github.com/hofstadter-io/hof/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "87703d19a23121a4b617f1359aed9616dceb6c79718245861835b61ccff7e1eb"
  license "Apache-2.0"
  head "https://github.com/hofstadter-io/hof.git", branch: "_dev"

  # Latest release tag contains `-beta`, which is not ideal
  # adding a livecheck block to check the stable release
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2871a88c2a9de3ed790e3c6ef7730a9932adb5ca0d918b60836e6cfda1e6e6f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e5275eb22672ae3f0bcf884becc77d6b34eda2b7ba84ffd3fe562fddbc3d5e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e5275eb22672ae3f0bcf884becc77d6b34eda2b7ba84ffd3fe562fddbc3d5e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e5275eb22672ae3f0bcf884becc77d6b34eda2b7ba84ffd3fe562fddbc3d5e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "96a01bb5adfdee2ac9d77baf10cdbd99682f95e487ea6fc9b0a0be59d3492c19"
    sha256 cellar: :any_skip_relocation, ventura:       "96a01bb5adfdee2ac9d77baf10cdbd99682f95e487ea6fc9b0a0be59d3492c19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0247c192be4a3d799e18e2c21587395e8294afcbb05daf3f2f91435f93e16743"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1649592d767a8d06f0db43de77032c854168d2626ba0113650942c1d3221e935"
  end

  depends_on "go" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    ldflags = %W[
      -s -w
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.Version=#{version}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.Commit=#{tap.user}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.BuildDate=#{time.iso8601}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.GoVersion=#{Formula["go"].version}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.BuildOS=#{os}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.BuildArch=#{arch}
    ]

    ENV["HOF_TELEMETRY_DISABLED"] = "1"
    system "go", "build", *std_go_args(ldflags:), "./cmd/hof"

    generate_completions_from_executable(bin/"hof", "completion")
  end

  test do
    ENV["HOF_TELEMETRY_DISABLED"] = "1"

    assert_match version.to_s, shell_output("#{bin}/hof version")

    system bin/"hof", "mod", "init", "brew.sh/brewtest"
    assert_path_exists testpath/"cue.mod"
    assert_match 'module: "brew.sh/brewtest"', (testpath/"cue.mod/module.cue").read
  end
end
