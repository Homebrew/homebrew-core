class Boa < Formula
  desc "Embeddable and experimental Javascript engine written in Rust"
  homepage "https://github.com/boa-dev/boa"
  url "https://github.com/boa-dev/boa/archive/refs/tags/v0.20.tar.gz"
  sha256 "10cc1e8c8f62b6fb0b22ec2ddc7031715f99bd8bed6168b14c93a89cb8dab597"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/boa-dev/boa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6511d59e732eb4093f55266cb82177c9561d461cdf6db8a300f6993c8f87e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065f0361e0ab41501e92db94e1cf043c5871ab29fbff039aed67255455a874d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08fb899017323c8854209da3d3b9190337803ef635a8b6a7d960f17141ccda6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2f8fba394237d297214d94a2f78a2da249cf19b481a7dcf0b41cde97b9ea2e6"
    sha256 cellar: :any_skip_relocation, ventura:       "e55c1d32124a5dc83dad035ec5d3e6631b10b3d9cf41a6a92c949fc47e3d29c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f78e3b85b68cf071b0ead92403cbbc1be6e54b8a2247ffcff31494834f76b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28ed6dc310185ff69da5a53d22b4c557b63dfa736557687ec11cc6591089b774"
  end

  depends_on "rust" => :build

  def install
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
