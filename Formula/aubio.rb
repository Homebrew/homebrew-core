class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.7.tar.bz2"
  sha256 "cbed4afec5ab3a1a6300c7e3af0a1369379aa94259f5e701a8ca905cdd9fa041"
  revision 2

  bottle do
    cellar :any
    sha256 "0a0f0aa930fe033f16662748bd27fae7b897e18d63b637eb5f3185b147230285" => :mojave
    sha256 "1bcfe7f151e3778a934a7b63ba2660d012e2dc87e54ea52393d46f4fb19ab402" => :high_sierra
    sha256 "1bb355e4fb82b09d4df4fb2c8b5a3f0537e6e8f660f22762da5255e36b9c4eae" => :sierra
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
