class Octomind < Formula
  desc "Plug and play AI agents for any domain"
  homepage "https://octomind.run"
  url "https://github.com/Muvon/octomind/archive/refs/tags/0.43.0.tar.gz"
  sha256 "89285c63b9f2442d4f0bf7e49f0c111a4d5204c2078144f87a250a419944d764"
  license "Apache-2.0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octomind --version")
  end
end
