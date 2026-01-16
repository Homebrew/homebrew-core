class Hof < Formula
  desc "Flexible data modeling & code generation system"
  homepage "https://hofstadter.io/"
  url "https://github.com/hofstadter-io/hof/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "87703d19a23121a4b617f1359aed9616dceb6c79718245861835b61ccff7e1eb"
  license "Apache-2.0"
  head "https://github.com/hofstadter-io/hof.git", branch: "_next"

  # Latest release tag contains `-beta`, which is not ideal
  # adding a livecheck block to check the stable release
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9646fbe9aedd3339cc3502d4dd1217c6bd8f2a207e17f2d4aee664b7e60ae281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9646fbe9aedd3339cc3502d4dd1217c6bd8f2a207e17f2d4aee664b7e60ae281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9646fbe9aedd3339cc3502d4dd1217c6bd8f2a207e17f2d4aee664b7e60ae281"
    sha256 cellar: :any_skip_relocation, sonoma:        "054e65b74ca1aebf0351cf1bcf145b7738aec5470c506c62d4b649d91bbc346b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0a4500b2b97316de21efb51fa8f5e7173576f91d80d3a04d2949398145deb12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4397be59f7e752c110cedf109d7cb9b8442105589f54e82e3e436c0561769fcc"
  end

  depends_on "go" => :build

  # patch to add Go 1.26 testDeps ModulePath, upstream pr ref, https://github.com/hofstadter-io/hof/pull/410
  patch do
    url "https://github.com/hofstadter-io/hof/commit/7d0389788a67be9bed36ab4d9ac8768b6890aff3.patch?full_index=1"
    sha256 "662ef04018e749a0772ad099af209fc4e0caefba4ee0e7633be33182e0741dae"
  end

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

    generate_completions_from_executable(bin/"hof", shell_parameter_format: :cobra)
  end

  test do
    ENV["HOF_TELEMETRY_DISABLED"] = "1"

    assert_match version.to_s, shell_output("#{bin}/hof version")

    system bin/"hof", "mod", "init", "brew.sh/brewtest"
    assert_path_exists testpath/"cue.mod"
    assert_match 'module: "brew.sh/brewtest"', (testpath/"cue.mod/module.cue").read
  end
end
