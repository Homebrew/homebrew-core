class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.4.0.tar.gz"
  sha256 "6d3ba783b68a425c3def6918bbfb48c828d0d56e8636b7afbebd12a40a7dc5d3"
  revision 1

  bottle do
    sha256 "115c7242b217df0ea30c94c449a610a541e34e01d8ef06f1c9b721725c0bffac" => :high_sierra
    sha256 "b0d845997c458fb6a92f9abfc0c4db8d34eb5d0db5c14e5f4f8c8e04f2a8d8fc" => :sierra
    sha256 "40352d820c106b1c4e62fa176b65ba141145cdcb66e3c9a384eefcd698246957" => :el_capitan
  end

  depends_on "crystal-lang"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
