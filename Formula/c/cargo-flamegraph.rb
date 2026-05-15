class CargoFlamegraph < Formula
  desc "Easy flamegraphs for Rust projects and everything else"
  homepage "https://github.com/flamegraph-rs/flamegraph"
  url "https://github.com/flamegraph-rs/flamegraph/archive/refs/tags/v0.6.12.tar.gz"
  sha256 "3b1158d30a5dd3496b271d5f55da47558cd84dd5ff7e11dbd67c2f6c51a3499e"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/flamegraph-rs/flamegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ce0f024a87509a438fee079d93d70f63cd9068b01c81984b6850c1a6162328d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84f859a356ad61ccdd3e1e1e889a16b8036582380fdafec3abb219d6f30be9d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71e75c663896193798511f3270c83af638f20a487358ecebac01424a096fc4f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "2d581620bb5f1d40d7442a17b9a215452f14f2000dd7b8253669b03a1f469fdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b99100ce01efccd05a2903c2c47585e72fa1a93f413b8a35dcb773ded059efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33a8014a49487033a3693fdd8fdb8563e3d0cf669b16148a39bac6194f73e61e"
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
