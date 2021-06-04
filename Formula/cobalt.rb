class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.16.5.tar.gz"
  sha256 "2586568420d2d75c0b2c23467e6bdce7fef653f5823c8ef223d0699611efc96e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e4d835eab621d0ac1f25654172e15acec1cf8d6c7a175257fcd8f2e2b3c82f90"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ca1b479a6a57d582035a3012bee0405c41d675c95669fa28de6dd7a3f28cb45"
    sha256 cellar: :any_skip_relocation, catalina:      "c3f7b8fcf776fe439bbcf1766db0b7da4088a20c05f3864d0f06c8bfd19f1ab1"
    sha256 cellar: :any_skip_relocation, mojave:        "25ab3e8ef46a1eaf6f7032d68f5930696783bb75add7d0b918b82cfb9fa58535"
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
