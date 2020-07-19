class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.7.1.tar.gz"
  sha256 "eb721634a725b24d1c00caa8bc14c2993d5d512a8d040993ada0e4744e180669"

  bottle do
    cellar :any_skip_relocation
    sha256 "9eb4b3a5521a34e7884d97f5d75a1fd867ac37a52223640ca527e98c96fda265" => :catalina
    sha256 "18d601ae975b6b52e6498fc0f5ec4357b9711618aeb8a8a715872d37f30d037f" => :mojave
    sha256 "e679739e9e4b02746f2286e9ef491279f827eab5bf3e33000d778449b790656a" => :high_sierra
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
