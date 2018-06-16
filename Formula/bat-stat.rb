class BatStat < Formula
  desc "Bayesian analysis toolkit"
  homepage "https://bat.mpp.mpg.de/"
  url "https://github.com/bat/bat/releases/download/v1.0.0/BAT-1.0.0.tar.gz"
  sha256 "620e8069d85f18f8504137823621cbb578fa5b159e3074f0f2379ac295dd1482"

  depends_on "root"
  depends_on "cuba" => :recommended

  option "with-multithreading", "Enable OpenMP multithreading support (gcc only)" if OS.linux?

  def install
    opts = ["--prefix=#{prefix}"]

    if build.without? "cuba"
      opts << "--with-cuba=no"
    else
      opts << "--with-cuba"
    end

    if build.with?("multithreading") && OS.mac?
      odie "Multithreading support is not available on OSX for this formula"
    end

    opts << "--enable-parallel" if build.with? "multithreading"

    system "./configure", *opts
    system "make", "install"
    (share/"BAT/examples").install "examples/basic"
    (share/"BAT/examples").install "examples/advanced"
  end

  test do
    system "#{share}/BAT/examples/basic/binomial/runEfficiency"
  end
end
