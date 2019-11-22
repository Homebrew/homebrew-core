class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/releases/download/v2.3.0/openexr-2.3.0.tar.gz"
  sha256 "fd6cb3a87f8c1a233be17b94c74799e6241d50fc5efd4df75c7a4b9cf4e25ea6"

  bottle do
    cellar :any
    sha256 "253c51ec98e9bd038d47d8482ea15e85183cc8dd718e5cf41facdfe9555f3717" => :catalina
    sha256 "111658d105dc894ea67e1fdc98597c73c1bf1fa64ac52f1287372ded53a1cdab" => :mojave
    sha256 "5673dfdc40bfc3f3495ec2fcff9ea5d5b65b244940f5bf686f79b838b97fdf3d" => :high_sierra
    sha256 "1418b449d38fbe7f37071ab6bf8f383d53d3540d41597be97eefdcc08749b7e3" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
