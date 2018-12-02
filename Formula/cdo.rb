class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/18911/cdo-1.9.6rc4.tar.gz"
  sha256 "c236f48f3c920a29b4e66aa3883eeb7666fc5b4ee7109b2d24f8618709f6b60b"

  depends_on "eccodes"
  depends_on "hdf5"
  depends_on "netcdf"
  depends_on "proj"
  depends_on "szip"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-eccodes=#{Formula["eccodes"].opt_prefix}
      --with-netcdf=#{Formula["netcdf"].opt_prefix}
      --with-hdf5=#{Formula["hdf5"].opt_prefix}
      --with-szlib=#{Formula["szip"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
  end
end
