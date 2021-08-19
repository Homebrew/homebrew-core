class Librespot < Formula
  desc "Open Source Spotify client library"
  homepage "https://github.com/librespot-org/librespot"
  url "https://github.com/librespot-org/librespot/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "cd6e7ae63583584598dead53b5e8e4077ab37df6e3b59c2a7416459b9a649fc3"
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
