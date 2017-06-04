class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.5.tar.bz2"
  sha256 "70c2804e6f4fbf0ebc0fb9ac8cc9d465ef4a4d438311c074c9a7364e98827af6"

  bottle do
    cellar :any
    sha256 "e72e6f6ca2562e43dd3b79755bac1741fbda2cc12c1adf41e19712da9eb292c7" => :sierra
    sha256 "d754ca2e173318c33fd6af21184fcbf7e9d739ece3c35b329f616483dc8696d3" => :el_capitan
    sha256 "c826af70ae0ac208299282b6935747736ef58d5505b9c7235c699590ac26020d" => :yosemite
  end

  option "with-python", "Build with python support"

  depends_on :macos => :lion
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "libav" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libsamplerate" => :optional
  depends_on "fftw" => :optional
  depends_on "jack" => :optional
  depends_on "numpy" if build.with? "python"

  def install
    # Needed due to issue with recent cland (-fno-fused-madd))
    ENV.refurbish_args

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    if build.with? "python"
      system "python", *Language::Python.setup_install_args(prefix)
      bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    end
  end

  test do
    if build.with? "python"
      system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    end
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
