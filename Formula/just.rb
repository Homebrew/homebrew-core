class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.8.4.tar.gz"
  sha256 "7aee472e4b70e62e89d7d5185493a3c680aeae4cc323c842e4c5b9b8af47040a"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f2ba1e974312ef1b70483c1d74bdf8f3c669e70872908b7014082b8959c4724a"
    sha256 cellar: :any_skip_relocation, big_sur:       "d72a96af3be4416741b7bed8a806ce6ee7b36355b355d663062d9fe32aa814d4"
    sha256 cellar: :any_skip_relocation, catalina:      "1d43b3fb6efcba5944483ba89d9b3b19af9b1745d1e7d5dcf2d047aa869a156d"
    sha256 cellar: :any_skip_relocation, mojave:        "5101411c95e187d0a1184029f5b11f45119e8438d68fb62c15c3303e75e9287e"
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
