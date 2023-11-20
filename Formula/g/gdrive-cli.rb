class GdriveCli < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/glotlabs/gdrive"
  url "https://github.com/glotlabs/gdrive/archive/refs/tags/3.9.0.tar.gz"
  sha256 "a4476480f0cf759f6a7ac475e06f819cbebfe6bb6f1e0038deff1c02597a275a"
  license "MIT"
  head "https://github.com/glotlabs/gdrive.git", branch: "main"

  depends_on "rust" => :build

  conflicts_with "gdrive", because: "gdrive also ships a gdrive binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Usage: gdrive <COMMAND>", shell_output("#{bin}/gdrive")
    assert_match version.to_s, shell_output("#{bin}/gdrive version")
    assert_match "Error: No accounts found", shell_output("#{bin}/gdrive account list")
    assert_match "Error: No account has been selected", shell_output("#{bin}/gdrive files list")
  end
end
