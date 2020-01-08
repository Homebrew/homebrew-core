class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.9.tar.bz2"
  sha256 "d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da"

  bottle do
    cellar :any
    sha256 "b542f8ab15932bc1b5f51c65ab00f7501d2054752823832fafbc5d2f0d87f0ac" => :catalina
    sha256 "1c011afadd6d9590101b46cb6f3bf530c5ddfb2cef0983bf4fea287ef5f8c265" => :mojave
    sha256 "f4d0585fe52669ce1c8f3b33e64af22219cc8623f27423bc7d9ce8c3f4e2351a" => :high_sierra
    sha256 "11ce710814cb514c434620c24fbb4504a3744747ae06dfe260bcdcfa6b69ef64" => :sierra
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
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
