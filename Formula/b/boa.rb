class Boa < Formula
  desc "Embeddable and experimental Javascript engine written in Rust"
  homepage "https://github.com/boa-dev/boa"
  url "https://github.com/boa-dev/boa/archive/refs/tags/v0.22.tar.gz"
  sha256 "fd12f2cc173e162d0775b6dd07d4cbde0fc2485661a816cc4ef12f8239db96e7"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boa-dev/boa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5f2c7e3daa24325b40f783569690beac926cf0ea858f59614757f47a0a0b8ed9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "734b4d4e1d779492698c4a3ff6fa71e831f4f3e4a11de3803d57448f2b96834b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "75ceb7e28892c7bbbeb8c530a32e13fccc4a8cece6cee118962bd28e3e77fd2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "af9dd97d7410112767e97197f3988df7e344c6ee8f3b289e82f4bf5bd61170be"
    sha256 cellar: :any,                 arm64_linux:       "3dfd882d066e3bfc0a595ce52cb8ad8d56567f34bec8af5e0da1c518e34489c7"
    sha256 cellar: :any,                 x86_64_linux:      "943d9c6050470900410b6887cf9a300f2dada0828a1497c7cfd4643884d4e804"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/boa --version")

    (testpath/"test.js").write <<~JS
      function factorial(n) {
        return n <= 1 ? 1 : n * factorial(n - 1);
      }
      console.log(`Factorial of 5 is: ${factorial(5)}`);
    JS

    output = shell_output("#{bin}/boa #{testpath}/test.js")
    assert_match "Factorial of 5 is: 120", output
  end
end
