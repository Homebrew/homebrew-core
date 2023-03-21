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
    ENV["AICHAT_API_KEY"] = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    output = shell_output("#{bin}/aichat --dry-run math 3.2x4.8")
    assert_match "math 3.2x4.8", output
  end
end
