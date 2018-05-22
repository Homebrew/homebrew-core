class Cdo < Formula
  desc "Climate Data Operators"
  homepage "https://code.mpimet.mpg.de/projects/cdo"
  url "https://code.mpimet.mpg.de/attachments/download/17451/cdo-1.9.5rc1.tar.gz"
  sha256 "cc6993e96a20d4b0829cb8f67dbc798e2ee7fa734198054e6c85bcc7d86e3f2e"

  depends_on "eccodes"
  depends_on "netcdf"
  depends_on "szip"
  depends_on "hdf5"
  depends_on "proj"
  #depends_on "magics"

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
