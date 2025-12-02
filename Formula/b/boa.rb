class Boa < Formula
  desc "Embeddable and experimental Javascript engine written in Rust"
  homepage "https://github.com/boa-dev/boa"
  url "https://github.com/boa-dev/boa/archive/refs/tags/v0.21.tar.gz"
  sha256 "aa6eb743cd6037e6b5efa6ba01ee8c5695b1406d141697ddd4578b047e8028bf"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boa-dev/boa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c487656c5ebb79333fa4f8a81afe8066f62059212dd0606c61fcefac52e9c064"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dae69096a640038b85e37d5532310514e46949c111b49f26eb9772d7fe3f0a14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbe6e48aa63dea3f82e8caace4a5564958986b62a3df0b48f6bbf8ae5fe09275"
    sha256 cellar: :any_skip_relocation, sonoma:        "ecff53c4ecf56567e1593a80abca460b61015f8a4fc93ebd26edfb6015d00584"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "733119d87455c4f1738bef0a532fe7869a9107548da834420c0b198a5fa08ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43062e155e024fee561efaf8951a02533d3f338acd229df0a4fa9b23f9c9b82d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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
