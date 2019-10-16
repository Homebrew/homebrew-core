class Binwalk < Formula
  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  url "https://github.com/ReFirmLabs/binwalk/archive/v2.2.0.tar.gz"
  sha256 "f5495f0e4c5575023d593f7c087c367675df6aeb7f4d9a2966e49763924daa27"
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
    url "https://files.pythonhosted.org/packages/ac/36/325b27ef698684c38b1fe2e546e2e7ef9cecd7037bcdb35c87efec4356af/numpy-1.17.2.zip"
    sha256 "73615d3edc84dd7c4aeb212fa3748fb83217e00d201875a47327f55363cef2df"
  end

  resource "scipy" do
    url "https://files.pythonhosted.org/packages/ee/5b/5afcd1c46f97b3c2ac3489dbc95d6ca28eacf8e3634e51f495da68d97f0f/scipy-1.3.1.tar.gz"
    sha256 "2643cfb46d97b7797d1dbdb6f3c23fe3402904e3c90e6facfe6a9b98d808c1b5"
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
