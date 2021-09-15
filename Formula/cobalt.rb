class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.17.4.tar.gz"
  sha256 "c50f06a6561f8e5ac5e5eb5c13cbd612ef810fc9e57d470d7793e69e243b4a52"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4d835eab621d0ac1f25654172e15acec1cf8d6c7a175257fcd8f2e2b3c82f90"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ca1b479a6a57d582035a3012bee0405c41d675c95669fa28de6dd7a3f28cb45"
    sha256 cellar: :any_skip_relocation, catalina:      "c3f7b8fcf776fe439bbcf1766db0b7da4088a20c05f3864d0f06c8bfd19f1ab1"
    sha256 cellar: :any_skip_relocation, mojave:        "25ab3e8ef46a1eaf6f7032d68f5930696783bb75add7d0b918b82cfb9fa58535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06be19fe98b9bf3d3129a63fbef010fbbcb28c7f43a234904dbe53dd0b5ab2b4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
