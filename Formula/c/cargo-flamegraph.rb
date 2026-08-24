class CargoFlamegraph < Formula
  desc "Easy flamegraphs for Rust projects and everything else"
  homepage "https://github.com/flamegraph-rs/flamegraph"
  url "https://github.com/flamegraph-rs/flamegraph/archive/refs/tags/v0.6.14.tar.gz"
  sha256 "c379e26dfacd4c7439456e488457b7f1cb651687c0eb596f4acd1964c6ffbd82"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/flamegraph-rs/flamegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83f571804c08bc5875bcea7ee3ca17180261ff3040d254d41ee2e50fb6b40578"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2c8c1c968f4adc1c53ca33c7f2894c242721d68570c840ef92e7d95436c9c1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feac145cef98a133277c5c3257c6fff74ae69805e5963036fae153616dda0d74"
    sha256 cellar: :any_skip_relocation, sonoma:        "b59194e6c7eb2496a7c4e3d09cbc8d3e13f53d6241c1488d86ee46e7f64e8b6d"
    sha256 cellar: :any,                 arm64_linux:   "80f233590788ec79d0c62c286d2497e6c2b64a68419b17097fa253cd2bfa56db"
    sha256 cellar: :any,                 x86_64_linux:  "fad30f85913415c69b2a4fe88318374219b306195fc82fa98ef51faf1d18a232"
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
