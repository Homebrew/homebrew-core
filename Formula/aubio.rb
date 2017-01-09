class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.4.tar.bz2"
  sha256 "2acdb92623b9d4ba641c387760ffe3ec1e4c6ab498e64e5e2286c99e36ffbff8"

  head "https://github.com/piem/aubio.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "1ea3665497c83878734eeb3efa6f899b661d21fe6d4e980515803878f604f5b9" => :sierra
    sha256 "dba88cd10bc1e3ad3669c7a5d1c8a3279e18d3fd2d6d4ccba628efe8a6d9e213" => :el_capitan
    sha256 "0f0d4a87a78046f088a640077d56d2adce0d19a59498f1b2e69e5027d740f84c" => :yosemite
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
