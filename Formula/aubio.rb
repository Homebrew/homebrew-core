class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.6.tar.bz2"
  sha256 "bdc73be1f007218d3ea6d2a503b38a217815a0e2ccc4ed441f6e850ed5d47cfb"

  bottle do
    cellar :any
    sha256 "652fd72fcb0937f082213939d18acadd35d39a7c8b790ba29746f628b55d81bc" => :high_sierra
    sha256 "65cfbadfb34422fcdc74d2d417cec9096b5289e8c4f1f18c9d4b512ada2337f2" => :sierra
    sha256 "ef260312d855772fb09146508d4b819e0a185f510ecb73fd52e033e3afebd246" => :el_capitan
  end

  option "with-python@2", "Build with python 2 support"

  deprecated_option "with-python" => "with-python@2"

  depends_on :macos => :lion
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "libav" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libsamplerate" => :optional
  depends_on "fftw" => :optional
  depends_on "jack" => :optional
  depends_on "numpy" if build.with? "python@2"

  def install
    # Needed due to issue with recent cland (-fno-fused-madd))
    ENV.refurbish_args

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    if build.with? "python@2"
      system "python", *Language::Python.setup_install_args(prefix)
      bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    end
  end

  test do
    if build.with? "python@2"
      system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    end
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
