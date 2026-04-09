class Boa < Formula
  desc "Embeddable and experimental Javascript engine written in Rust"
  homepage "https://github.com/boa-dev/boa"
  url "https://github.com/boa-dev/boa/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "fd0a45ff94673120f010d19dc44c411bc8fc5dcd3e5986e6f1dd5f005f918f22"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boa-dev/boa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e17114c6147b4911e8dce508ea3f9001be39690e0ee52547043caae40bb1a47"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b0c4732ea24156489c85dbecc161449f34aaa4e3b7e4110e18badfa5c1c778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e809b2bb6aa9cdbc162da2fefa4e0f30c49edb3899935c457ea10e9c9115d6a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f7ec93e805d5b4fc75ff6e466e80fc4590efcfe7cd69f7f0a0bcd726fdf76a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7479bb490fae1e207d92bce71e2af2e5ecfb4d5ff3a405fdd5c38a453b15fc5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c083f6db35bd00c0ac4cf40a1fa6b29af35795853ad738cb30394856a57baa70"
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
