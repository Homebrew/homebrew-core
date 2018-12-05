class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.7.tar.bz2"
  sha256 "cbed4afec5ab3a1a6300c7e3af0a1369379aa94259f5e701a8ca905cdd9fa041"
  revision 1

  bottle do
    cellar :any
    sha256 "36711680d58975f60c38d2ad9775afe4897f1b8328257cc3089a25617765ed15" => :mojave
    sha256 "99017df7e892a6c7ef892d882c730201c89a2c34d0603533b4d31dede77f5ead" => :high_sierra
    sha256 "cc3bef276f2980e2cfd44abb9cf45ffa68da6ef47001a9a526d484d7993be142" => :sierra
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
