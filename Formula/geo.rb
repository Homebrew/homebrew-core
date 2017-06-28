class Geo < Formula
  desc "Bash utility for network and ip geodata, with clean output for piping"
  homepage "https://github.com/jakewmeyer/Geo"
  url "https://github.com/jakewmeyer/Geo/archive/v0.1.4.tar.gz"
  sha256 "9be1ee5aa8578bd257c79c5a13503161451d8fcba19573ba41458e3a0c805801"

  def install
    bin.install "geo"
  end

  test do
    system "#{bin}/geo", "-w"
  end
end
