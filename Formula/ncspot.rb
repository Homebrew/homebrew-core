class Ncspot < Formula
  desc "Cross-platform ncurses Spotify client written in Rust"
  homepage "https://github.com/hrkfdn/ncspot"
  url "https://github.com/hrkfdn/ncspot/archive/v0.2.4.tar.gz"
  sha256 "faf789ddc83db718874fbd71838996574b52008bf3192171c435f533bc769916"
  license "BSD-2-Clause"

  depends_on "python3" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install",
      "--no-default-features", "--features", "rodio_backend,cursive/pancurses-backend", *std_cargo_args
  end

  test do
    # Same test as ncmpc
    system bin/"ncspot", "--help"
  end
end
