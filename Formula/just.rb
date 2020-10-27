class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.8.2.tar.gz"
  sha256 "a137dc2633487a87d3d97cc40a359a84f96b3be2ff7153fe453c45728618523f"
  license "CC0-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f3ff506e27d07bcd3b7415e141197d2b6d35aabc49e0f213cf7a968ad2f875c" => :catalina
    sha256 "32b820046fe98a158d8fb339e37fa6cdeaf6fa9507dcd20084dd6f40f1e46e4a" => :mojave
    sha256 "3bc44189de2528cd8e7113efe42515de9b919431186888592e46a5fdd656c5c6" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
