class Plakar < Formula
  desc "Backup solution powered by Kloset and ptar"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "425f551c5ade725bb93e3e33840b1d16187a6f8ec47abfe4830deefc5b70b2f8"
  license "ISC"
  head "https://github.com/PlakarKorp/plakar.git", branch: "main"

  depends_on "go" => ["1.23.3", :build]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"plakar", "agent", "-foreground"]
    keep_alive true
    run_type :immediate
  end

  test do
    system bin/"plakar", "at", "backups", "create", "-no-encryption"
    assert_path_exists testpath/"backups"

    assert_match version.to_s, shell_output("#{bin}/plakar version")
  end
end
