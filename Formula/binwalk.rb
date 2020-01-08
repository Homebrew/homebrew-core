class Binwalk < Formula
  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  url "https://github.com/ReFirmLabs/binwalk/archive/v2.2.0.tar.gz"
  sha256 "f5495f0e4c5575023d593f7c087c367675df6aeb7f4d9a2966e49763924daa27"
  head "https://github.com/ReFirmLabs/binwalk.git"

  bottle do
    cellar :any
    sha256 "e95a1061cccebe8b26ade0344cfec88d987f0344c0ef3ef0dae1ca9d7e2304ec" => :catalina
    sha256 "aade25dafcf47d5a9b4e8c51f8e5aba3fe3c9e09cd2a592aec68a7e685741ee0" => :mojave
    sha256 "ddf7030e8ff4e1f5a2aed178b1ccff13f3e6e5428bd23ab63679fbaeeb89ac80" => :high_sierra
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
