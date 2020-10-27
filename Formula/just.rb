class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.8.2.tar.gz"
  sha256 "a137dc2633487a87d3d97cc40a359a84f96b3be2ff7153fe453c45728618523f"
  license "CC0-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4bad1156644662edb520f9a7c0bfb080333c92355f01506ddfbb142b189f1d69" => :catalina
    sha256 "3882ebe9e3ba3a9a6df550fd1efdafc399db72926b658580388ee039bd4e4366" => :mojave
    sha256 "93cb8613517af9f8a600acef13b889174d99df621c0008ab3069f491fb4ae183" => :high_sierra
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
