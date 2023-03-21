class Aichat < Formula
  desc "ChatGPT cli"
  homepage "https://github.com/sigoden/aichat"
  url "https://github.com/sigoden/aichat/archive/v0.8.0.tar.gz"
  sha256 "9073d96afdab56ff51f392cffa8d04fd70d47602236bd10e58248de5594bfd2a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/sigoden/aichat.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    version_out = shell_output("#{bin}/aichat --version")
    assert_match "aichat #{version}", version_out
  end
end
