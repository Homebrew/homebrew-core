class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.7.tar.bz2"
  sha256 "cbed4afec5ab3a1a6300c7e3af0a1369379aa94259f5e701a8ca905cdd9fa041"
  revision 1

  bottle do
    cellar :any
    sha256 "30989079f321e3c97ac1528403cda58c4e0cd996c387c0e4559a804138da28fc" => :mojave
    sha256 "ae3df38f537cda54d57490393f3ab278067987069560e4f80e7b7a4bfec9be12" => :high_sierra
    sha256 "6c7443553954e8a676238b84f8f60a39bd03ac956c236e40350b9ee8212b9c65" => :sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on :macos => :lion
  depends_on "numpy"
  depends_on "python"

  def install
    # Needed due to issue with recent clang (-fno-fused-madd))
    ENV.refurbish_args

    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"

    system "python3", *Language::Python.setup_install_args(prefix)
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
