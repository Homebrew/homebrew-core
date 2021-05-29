class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.16.5.tar.gz"
  sha256 "2586568420d2d75c0b2c23467e6bdce7fef653f5823c8ef223d0699611efc96e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "caee79fdc34ee2eb51db19a6a7176fb21025ef71e269398f20dae169c1641fe5"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b854d8526d71f6f12181ed8c7c7512bd6d8b971c8230f0b40c02af67e124f45"
    sha256 cellar: :any_skip_relocation, catalina:      "ece5edf627390bd8aa6a7f2b423f1e8fd87122570531edafe8bf7a2c8ef2d917"
    sha256 cellar: :any_skip_relocation, mojave:        "53d8b9854325201c5a490a912f75489f691e7f0bb8935bbd3d5266d548c4619f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8f4416c77f2c1a20bda2e74cafde341602eefeecc03e81f719e08a1872c2c369"
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
