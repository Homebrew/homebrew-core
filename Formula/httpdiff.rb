class Httpdiff < Formula
  desc "Compare two HTTP(S) responses"
  homepage "https://github.com/jgrahamc/httpdiff"
  url "https://github.com/jgrahamc/httpdiff/archive/v1.0.0.tar.gz"
  sha256 "b2d3ed4c8a31c0b060c61bd504cff3b67cd23f0da8bde00acd1bfba018830f7f"

  head "https://github.com/jgrahamc/httpdiff.git"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"httpdiff"
  end

  test do
    system bin/"httpdiff", "http://brew.sh", "http://brew.sh"
  end
end
