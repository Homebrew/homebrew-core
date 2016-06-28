class Certigo < Formula
  desc "Utility to examine and validate certificates in a variety of formats"
  homepage "https://github.com/square/certigo"
  url "https://github.com/square/certigo.git"
  version "1.0.0"
  sha256 "935d4092e232099b1001680ac76dafb6e144898bb8dc7397529a6b78655db52d"

  depends_on "go" => :build

  def install
    system "./build"
    bin.install "bin/certigo"
  end

  test do
    system "certigo", "help"
  end
end
