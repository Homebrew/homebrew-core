class Binwalk < Formula
  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  url "https://github.com/ReFirmLabs/binwalk/archive/v2.1.1.tar.gz"
  sha256 "1b70a5b03489d29f60fef18008a2164974234874faab48a4f47ec53d461d284a"
  revision 7
  head "https://github.com/ReFirmLabs/binwalk.git"

  bottle do
    cellar :any
    sha256 "d69df080621aed61fccfc2efe7424b59e48356a39dc1cf2b4a8b920b9f1b3051" => :catalina
    sha256 "6b5e5e6d141f39f0660b0f99c26b9d9fd46fa91aa4dd58f8c30c4c1fd4fbbabe" => :mojave
    sha256 "956a8472894cb45f180ff7ed215e1ee1d32f970f45645e472e0d3678478714bf" => :high_sierra
    sha256 "2d3a67d85512443840a04e351b9488a3454f2164beb2151772abcca0185a604d" => :sierra
  end

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "p7zip"
  depends_on "python"
  depends_on "ssdeep"
  depends_on "xz"

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/45/ba/2a781ebbb0cd7962cc1d12a6b65bd4eff57ffda449fdbbae4726dc05fbc3/numpy-1.15.2.zip"
    sha256 "27a0d018f608a3fe34ac5e2b876f4c23c47e38295c47dd0775cc294cd2614bc1"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/07/76/7e844757b9f3bf5ab9f951ccd3e4a8eed91ab8720b0aac8c2adcc2fdae9f/scipy-1.1.0.tar.gz"
    sha256 "878352408424dffaa695ffedf2f9f92844e116686923ed9aa8626fc30d32cfd1"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[numpy scipy].each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
