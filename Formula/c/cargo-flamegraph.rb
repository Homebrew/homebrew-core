class CargoFlamegraph < Formula
  desc "Easy flamegraphs for Rust projects and everything else"
  homepage "https://github.com/flamegraph-rs/flamegraph"
  url "https://github.com/flamegraph-rs/flamegraph/archive/refs/tags/v0.6.11.tar.gz"
  sha256 "371f81e674abe70cdaf3478d7d6ab04cee0b5af174767a858f45c5c42206089e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/flamegraph-rs/flamegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae0959bdde7eee2a73cca05edb1a9417522ec8dd7c58f406625fdf6ef5cde5c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7285c8a79648b93876b6013c4ae1e1c615a09b6722e123b6a7470db110b59e79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c73837d2112ba60af980e04502bf9a77ee3cd71a8a7c0297df07b9477b287e49"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4ac8faf0ea320f484b299bdb2919efc9f6c779134174d32333bd335d0223857"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3efffd53380a13ba48f38fe4ba6ac87e38c941bebed189af5d641dfc9dbbb742"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c1cdce6946ebe6b39185c46e4442eb98bd4e3621074137304a6610796898494"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"flamegraph", "--completions")
  end

  test do
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV.prepend_path "PATH", Formula["rustup"].bin
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
