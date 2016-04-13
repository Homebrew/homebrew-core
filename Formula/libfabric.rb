class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.3.0/libfabric-1.3.0.tar.bz2"
  sha256 "0a0d4f1a0d178d80ec336763a0fd371ade97199d6f1e884ef8f0e6bc99f258c9"

  bottle do
    sha256 "fb5c566ee556d050f53f19568f752cb5bab989ef01198eddd1b64df26cbdbcdc" => :el_capitan
    sha256 "34ad02c68e5d921bcf0e0d5086aeb0cbb39157353bbc7dba4cf03d3e4fcbb748" => :yosemite
    sha256 "e3f95c8408b8b0ec925c65c812a4f1aec3206b1363dfe8fb85d886c099b7b6cd" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
