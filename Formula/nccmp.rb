class Nccmp < Formula
  desc "Compare two NetCDF files bitwise, semantically or with a tolerance"
  homepage "https://gitlab.com/remikz/nccmp"
  url "https://gitlab.com/remikz/nccmp/-/archive/1.8.6.1/nccmp-1.8.6.1.tar.gz"
  sha256 "5b30245dbad04afd6f349010b34e404c316671ac69ea778d4b3c5d12b680ed7c"

  depends_on "netcdf"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cdl").write("netcdf {}")
    system "ncgen", "-o", testpath/"test1.nc", testpath/"test.cdl"
    system "ncgen", "-o", testpath/"test2.nc", testpath/"test.cdl"
    assert_equal `#{bin}/nccmp -mds #{testpath}/test1.nc #{testpath}/test2.nc`,
                 "Files \"#{testpath}/test1.nc\" and \"#{testpath}/test2.nc\" are identical.\n"
  end
end
