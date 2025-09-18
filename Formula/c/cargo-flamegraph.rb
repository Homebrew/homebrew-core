class CargoFlamegraph < Formula
  desc "Easy flamegraphs for Rust projects and everything else"
  homepage "https://github.com/flamegraph-rs/flamegraph"
  url "https://github.com/flamegraph-rs/flamegraph/archive/refs/tags/v0.6.9.tar.gz"
  sha256 "dd9b83affab5f9c1eaad0de9034037780e634c96fef4dce8fa83900e58cc240c"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/flamegraph-rs/flamegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f02254cf91b45fdeddf7e5696f43560732cc3056ec1faeccd81c035f9dabf94a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a59f05d6020179a23e317e1894113b9665760a2b2b1588e5042dad8933dc54a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c34cf2d2a3a4fc582c0fc98a118c0fb381a620b089631bf3e8d4d7268391e86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fe08c54e9de5f7c0db4022825d0da8e8df9f3fec8b1c1150c4f67912ab7aeaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5206a7fe6e44731c1c64d08ba0e53c379b9f550bdf163e9f0378fe549fcebcb"
    sha256 cellar: :any_skip_relocation, ventura:       "ae76d5fc3ffbaf1275c38909818db298c0440b7e7b2648637258753fa6ffdb16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42cf582472a881a89e88d319cee00bb773558e34c6a76a5e88993785cfc341a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3f4e20aa6e5f0e73072baff1801f85eb51fb11e80203f6c32a7b45d305e8571"
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
