class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.18.3.tar.gz"
  sha256 "32350ef91a0c1dd81b75e8eb94f5a591ca91bd35d1a6d97622996b1086d5ced2"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a09a290ada2f823546c64ee1fdea75cd5ad8837d8756c22a5251dbed714e4eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0dda7dc3c9a126d01aa1311fc1707cb7b3659a1c7db8018385805e33c1bf93e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2da76763978a241499e834b64cd426e4ca433b3bb788b8d2cb63abd11dc79dd6"
    sha256 cellar: :any_skip_relocation, ventura:        "fe7635679364c2f6f8ee3c9b63c82ff977e7fd4567691415b30437e1f3197892"
    sha256 cellar: :any_skip_relocation, monterey:       "752ade1ce839efa00159f712a04af7ee87ffdb14b972be3cd1e8b63621e75bba"
    sha256 cellar: :any_skip_relocation, big_sur:        "bad62b23d320b35889ae0d95abb8837efc135e04d4910a0a2cf1b6ee7cddf33c"
    sha256 cellar: :any_skip_relocation, catalina:       "b9f9a00ecbed764a7069accb681f8e6a4cb443f45374f964db0b123b460e75b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5c6c9824431659a097830b65fd1b8f812d8268eef9464a1e1201ebcd6940d4b"
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
