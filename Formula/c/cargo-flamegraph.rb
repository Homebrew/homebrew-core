class CargoFlamegraph < Formula
  desc "Easy flamegraphs for Rust projects and everything else"
  homepage "https://github.com/flamegraph-rs/flamegraph"
  url "https://github.com/flamegraph-rs/flamegraph/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "2673a04bd4de142220d42706e0c25a4dea08aee52cdffbf87cca5738cec649ff"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/flamegraph-rs/flamegraph.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "740ef8f614bf69783f1d25c138bc5eb7e57f0318d05ecb87c1de8796a84c6190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "933b50f514c63ed78874e8443330c4e01fa0284c33f3b4dd2739d19233e5118e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "745ed3bedef3ac3b3a17a589edfe3321bd2731e4b1036cfaadfab9e7a5b37aee"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d5c2847b5ec9787c6b4ca4b71dfd959c6171e283d0bd5752cef352e6417d1f4"
    sha256 cellar: :any_skip_relocation, ventura:       "f2af510d43d381717f9ef3b1b8a631a9ce37a1b3c87d35126bb2e3e593e73254"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53d4cd9e5880a2a350ab626769520f62c130060ab69a1c60f6b14f015583e695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f1a3f5a80fb194e66fe415e19881ecc18ebda99abac0a049988fc9d54954780"
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
