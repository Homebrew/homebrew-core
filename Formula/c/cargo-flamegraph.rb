class CargoFlamegraph < Formula
  desc "Easy flamegraphs for Rust projects and everything else"
  homepage "https://github.com/flamegraph-rs/flamegraph"
  url "https://github.com/flamegraph-rs/flamegraph/archive/refs/tags/v0.6.13.tar.gz"
  sha256 "d8591f79c8abd46899fddfa692e4ab9da219672e0e203cd9482d77411d07bda1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/flamegraph-rs/flamegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "096cc4c0e5d4b39cd3b703a5dee2978298e3499e0a34b8f84aad92a4f660257c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f7b3bcd5ea7cc95cc574365d5accc08a96708c1a9d127c29d86931a9853639f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "972135e3e578228352df9a650dd7ce68c473a12f58d23e5e6619449385dc8da1"
    sha256 cellar: :any_skip_relocation, sonoma:        "98b85abdf583a1987e79c377e1d3306110869e955909b703e257a5535630b8cc"
    sha256 cellar: :any,                 arm64_linux:   "bef636b3be74c550db7e2855ddb029d1200824be9b915e25897594a44e94d106"
    sha256 cellar: :any,                 x86_64_linux:  "acb78570fb11ebc441e87a8d11b4cbc6913d60f6d8076db6cae37722275e3fd7"
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
