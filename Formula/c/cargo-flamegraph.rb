class CargoFlamegraph < Formula
  desc "Easy flamegraphs for Rust projects and everything else"
  homepage "https://github.com/flamegraph-rs/flamegraph"
  url "https://github.com/flamegraph-rs/flamegraph/archive/refs/tags/v0.6.10.tar.gz"
  sha256 "36dcd88cf872b6d0206dd2b684b3d4b99158d2960f5aa4f84d97677ea5ef0ae9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/flamegraph-rs/flamegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cac3686b3a7c6581fc1f7c1b5b522065bd345c5fdc1e6657d8015e6275d9d005"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3690c71d19172d86c61343829038ec44ebb5c7e3aff0445d5c8ce9e4a8619830"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a7a8600dfc61330fbbe7dd2fcb16a4d8e7653a986c26f50daae65ec837ca7ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5b726a149bfd28d8c0a9063fb4ae63f7469c768d5c5c7bdfca8970670c53a09"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60854739ec68360b210a4bbda391bfb020ef240765c56b7b2df9aa295fa1928e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27f408e44261ce0cea8f8a65464bea6dccf76629c91028ffcce06328c274a4a2"
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
