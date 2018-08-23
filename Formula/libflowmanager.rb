class Libflowmanager < Formula
  desc "Flow-based measurement tasks with packet-based inputs"
  homepage "https://research.wand.net.nz/software/libflowmanager.php"
  url "https://research.wand.net.nz/software/libflowmanager/libflowmanager-3.0.0.tar.gz"
  sha256 "0866adfcdc223426ba17d6133a657d94928b4f8e12392533a27387b982178373"

  bottle do
    cellar :any
    sha256 "5fa3ce0917567cf4baf9c72b4a8f2fd5ebe013fd58371c213ceffbb46c946586" => :mojave
    sha256 "52ebf18a6e9816920a0d44c09e9694c59524854d89e277e87486b81b995a6a60" => :high_sierra
    sha256 "56f84519f766ec0c4fcb47401851743070649a46b6f84707650256601e2ed04d" => :sierra
    sha256 "62ab34fafd7cd64356c2c6d185f76709539cca3c55b3ca7e41473ee79ddbae7f" => :el_capitan
  end

  depends_on "libtrace"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
