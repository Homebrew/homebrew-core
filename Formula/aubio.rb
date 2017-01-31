class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.4.tar.bz2"
  sha256 "2acdb92623b9d4ba641c387760ffe3ec1e4c6ab498e64e5e2286c99e36ffbff8"

  head "https://github.com/piem/aubio.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "e72e6f6ca2562e43dd3b79755bac1741fbda2cc12c1adf41e19712da9eb292c7" => :sierra
    sha256 "d754ca2e173318c33fd6af21184fcbf7e9d739ece3c35b329f616483dc8696d3" => :el_capitan
    sha256 "c826af70ae0ac208299282b6935747736ef58d5505b9c7235c699590ac26020d" => :yosemite
  end

  option :universal

  depends_on :macos => :lion

  depends_on :python => :optional
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  depends_on "libav" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libsamplerate" => :optional
  depends_on "fftw" => :optional
  depends_on "jack" => :optional

  if build.with? "python"
    depends_on "numpy" => :python
  end

  def install
    ENV.universal_binary if build.universal?

    # Needed due to issue with recent cland (-fno-fused-madd))
    ENV.refurbish_args

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"

    if build.with? "python"
      cd "python" do
        system "python", *Language::Python.setup_install_args(prefix)
        bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
      end
    end
  end

  test do
    if build.with? "python"
      system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    end
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
