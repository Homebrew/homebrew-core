class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.6.tar.bz2"
  sha256 "bdc73be1f007218d3ea6d2a503b38a217815a0e2ccc4ed441f6e850ed5d47cfb"
  revision 1

  bottle do
    cellar :any
    sha256 "2c395da96fbf17a3c8d5dc876a5e227b7a2b7a32cd09835b04f30aa19058b682" => :mojave
    sha256 "aa38cdd6191590eed102eb940da4e8e21daf5fc3628a747360d09b269c18cbf2" => :high_sierra
    sha256 "cbca234f689b0f8daae34c15df6234b5477fac3723fe2bb140f693746b1d86f3" => :sierra
    sha256 "ad6cdea7d6a62f5b6d4101f4b4225e4d4fe4f940d5ab0eae8cdf1b1cf3a60d01" => :el_capitan
  end

  depends_on :macos => :lion
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "numpy"
  depends_on "python@2"
  depends_on "libav" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libsamplerate" => :optional
  depends_on "fftw" => :optional
  depends_on "jack" => :optional

  def install
    # Needed due to issue with recent cland (-fno-fused-madd))
    ENV.refurbish_args

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    system "python", *Language::Python.setup_install_args(prefix)
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
