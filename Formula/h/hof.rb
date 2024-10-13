class Hof < Formula
  desc "Flexible data modeling & code generation system"
  homepage "https://hofstadter.io/"
  url "https://github.com/hofstadter-io/hof/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "aa6e084dbf8a74015504fd0e57c127c6322bf824df4a70c17990094786184665"
  license "Apache-2.0"
  head "https://github.com/hofstadter-io/hof.git", branch: "_dev"

  # Latest release tag contains `-beta`, which is not ideal
  # adding a livecheck block to check the stable release
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2f94e6653aa5030b3e177e6d6051f6733af0233509bb790c758bbd02a315a8a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4ccedb6755fdc995d502849ccffebb0a51e59ff3cbf6ce2232cd24d15c5bdaaf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1b413667d13da04682d19bd40c8ab78ddbf48cb8fef4a1c79479eda809e58da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a0b74bf4992814717e57969cc7cc23c556275138e83f9c15aa225f0f35211ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "e327c3c7a761cc3cdf2eb580a78a37a2e929430744f910db33555ed4a5c69cf3"
    sha256 cellar: :any_skip_relocation, ventura:        "55c524f609fa8adb0c4048eb4e7389e1a1569e43893c354d82232f324943641d"
    sha256 cellar: :any_skip_relocation, monterey:       "a71495af62fed30a8af15c556b8799c2b27a326a3cb9a2a74bcfbb94f5d90ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2d2c72ae5c2d63f628e369a67798ed8bd8da5fe57856f448b961bf600d7f881"
  end

  # use "go" again after https://github.com/hofstadter-io/hof/issues/391 is fixed and released
  depends_on "go@1.22" => :build

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    ldflags = %W[
      -s -w
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.Version=#{version}
      -X github.com/hofstadter-io/hof/cmd/hof/verinfo.Commit=
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
    assert_predicate testpath/"cue.mod", :exist?
    assert_match 'module: "brew.sh/brewtest"', (testpath/"cue.mod/module.cue").read
  end
end
