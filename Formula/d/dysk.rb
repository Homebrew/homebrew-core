class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  stable do
    url "https://github.com/Canop/dysk/archive/refs/tags/v2.8.0.tar.gz"
    sha256 "6cc8b5abd0d71c6d180006d52318405f9d49f72e724bd5965934c8992e0d1c26"

    # fix version display, remove in next release
    patch do
      url "https://github.com/Canop/dysk/commit/19fe54925b3020e9636623b423870da7e272a938.patch?full_index=1"
      sha256 "86abdaf3c02aed7062b1f918365cd26ee5700004eb3a45b01ccf7800159e1ca4"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bc801aeacb48fd45b77acca02c29fcc6d8d26aa0f6c4ef529272a57dd8901915"
  end

  depends_on "rust" => :build
  depends_on :linux

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end
