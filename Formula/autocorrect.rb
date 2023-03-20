class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://github.com/huacnlee/autocorrect"
  url "https://github.com/huacnlee/autocorrect/archive/v2.6.2.tar.gz"
  sha256 "550d94c3e465a0827a86bdfa23fa82c84a5ddf08fd9e9efb5e45f788bfa65b27"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "194977e0bfb23bcdc6dd19d8cb9047ef3fd1c2a4bc6b04da736ef33efe0fddef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67b3957215582cb1aade0a41410596ed1c7311f273e755c54edd889fb1d84a9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8efb4adf7d8620d709f3c36dd537641038dbc54f5ec56d6215ce76e2b04592b6"
    sha256 cellar: :any_skip_relocation, ventura:        "dc96b1b9e519d30696a772d24653f9fa6a02902923a862e85a2396dbba2b1f5a"
    sha256 cellar: :any_skip_relocation, monterey:       "915d064c7a2e498332fcda6aee031ab0b8d27cd40e45c33741bcdf62b7bef831"
    sha256 cellar: :any_skip_relocation, big_sur:        "65f443c9a5bd920caa438da95245dccd33d2f77112a41945f8bf4ed2a58b8434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42c145ed2db0c307a8f46961c717b2aebfebf32e813f0d1d8fc74a45ad5e88cc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_equal "Hello 世界", out
  end
end
