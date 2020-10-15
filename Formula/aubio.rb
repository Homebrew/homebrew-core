class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.9.tar.bz2"
  sha256 "d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da"
  revision 1

  livecheck do
    url "https://aubio.org/pub/"
    regex(/href=.*?aubio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "933eeaef88547341ec684e7aa422dc92e6864a06caa211d8d988608da577a4b1" => :catalina
    sha256 "0680687b55f8de23fde5c71d0dd1767552ef87642dba588ce572de441029c493" => :mojave
    sha256 "e98d68d3cb9a8576990b5c3ba75a2b7acb71e4f3196365a0c560878ab5258141" => :high_sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "python@3.8"

  def install
    # Needed due to issue with recent clang (-fno-fused-madd))
    ENV.refurbish_args

    system Formula["python@3.8"].opt_bin/"python3", "./waf", "configure", "--prefix=#{prefix}"
    system Formula["python@3.8"].opt_bin/"python3", "./waf", "build"
    system Formula["python@3.8"].opt_bin/"python3", "./waf", "install"

    system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/aubiocut", "--verbose", "/System/Library/Sounds/Glass.aiff"
    system "#{bin}/aubioonset", "--verbose", "/System/Library/Sounds/Glass.aiff"
  end
end
