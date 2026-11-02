class CargoFlamegraph < Formula
  desc "Easy flamegraphs for Rust projects and everything else"
  homepage "https://github.com/flamegraph-rs/flamegraph"
  url "https://github.com/flamegraph-rs/flamegraph/archive/refs/tags/v0.6.15.tar.gz"
  sha256 "794bf93418378a96358de2fcc6eeb82eed28b2fc7b8b019da0bd5b0427e452a5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/flamegraph-rs/flamegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a87c24899d33404aea909639570ae76f44e4f9dbb7bdd99e901f6598324be3b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "86bd98f347477ac69457d1105949e3c770cdfd7659aa5cd20d36b043322039d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d869a661e92b2b078f128d62a828ca025b485acdbd22d1c605c0a685f6372859"
    sha256 cellar: :any,                 arm64_linux:       "5dd93a2d4483ff739af46d15c02da9d21b5a0b39e8d5089a9f4146085eaa9d3e"
    sha256 cellar: :any,                 x86_64_linux:      "8f4200132bb905e2eb40a19cb24af8a2e4975156832b16a3006694b7a4839c25"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"flamegraph", shell_parameter_format: "--completions=")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", formula_opt_bin("rustup")
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "beta"

    assert_match version.to_s, shell_output("#{bin}/flamegraph --version")

    system "cargo", "new", "testproj", "--bin"
    cd "testproj" do
      system "cargo", "build", "--release"
      assert_match "WARNING: profiling without debuginfo", shell_output("cargo flamegraph 2>&1", 1)
    end

    expected = if OS.mac?
      "failed to sample program"
    else
      "perf is not installed or not present"
    end
    assert_match expected, shell_output("#{bin}/flamegraph -- echo 'hello world' 2>&1", 1)
  end
end
