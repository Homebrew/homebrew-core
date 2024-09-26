class MacStorageManager < Formula
  desc "A tool to manage storage by calculating application sizes on macOS"
  homepage "https://github.com/NarekMosisian/mac-storage-manager"
  url "https://github.com/NarekMosisian/mac-storage-manager/archive/v1.0.0.tar.gz"
  sha256 "e57bd1998480157cf4fccfd9f0cf02b40de437aa614750fa1ccce1f5ac74a6ca"

  license "MIT"

  depends_on "jq"
  depends_on "parallel"
  depends_on "newt"

  def install
    bin.install "application_size_checker.sh"
  end

  test do
    system "#{bin}/application_size_checker.sh", "--help"
  end
end

