class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot.git",
      tag:      "v0.2.0",
      revision: "59683d7965480e63c581dd03082ded6a080a1cd3"
  license "MIT"
  head "https://github.com/librespot-org/librespot.git", branch: "dev"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", "--features", "rodio-backend,with-dns-sd", *std_cargo_args
  end

  test do
    system "#{bin}/librespot", "-V"
  end
end
