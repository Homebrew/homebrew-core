class CargoFlamegraph < Formula
  desc "Easy flamegraphs for Rust projects and everything else"
  homepage "https://github.com/flamegraph-rs/flamegraph"
  url "https://github.com/flamegraph-rs/flamegraph/archive/refs/tags/v0.6.7.tar.gz"
  sha256 "d7fa901673f4ece09226aeda416b98f919b7d946541ec948f1ef682bd6eec23b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/flamegraph-rs/flamegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83b62778b73581c7e53152c4e73fd438b68bb8beeee5102811d8ae4d40e89f75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ede9bd1f60031ed9e4d923108fd437297e436d4086aca244bf8c9758061ff17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64a11d47c7eec1f0763a07f464e6fbf0f69585f4292a17fe76bbdda2170f7eab"
    sha256 cellar: :any_skip_relocation, sonoma:        "36249021702766ea6d42e784c76167a45286238a3252220128e6cd6c2ddc2bce"
    sha256 cellar: :any_skip_relocation, ventura:       "3d318a74ddf55a95efd0e7c266269db79bb3ca206d8175422d1f64b17fdc2844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc5ec07e6bec4c930cffa793537cab6f01569e5a7a44915201505003c7badcd7"
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
    system "rustup", "default", "beta"
    system "rustup", "set", "profile", "minimal"

    assert_match version.to_s, shell_output("#{bin}/flamegraph --version")

    system "cargo", "new", "testproj", "--bin"
    cd "testproj" do
      system "cargo", "build", "--release"
      expected = if OS.mac?
        "Error: DTrace requires elevated permissions"
      else
        "WARNING: profiling without debuginfo"
      end
      assert_match expected, shell_output("cargo flamegraph 2>&1", 1)
    end

    expected = if OS.mac?
      "failed to sample program"
    else
      "perf is not installed or not present"
    end
    assert_match expected, shell_output("#{bin}/flamegraph -- echo 'hello world' 2>&1", 1)
  end
end
