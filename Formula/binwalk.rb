class Binwalk < Formula
  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/devttys0/binwalk"
  url "https://github.com/devttys0/binwalk/archive/v2.1.1.tar.gz"
  sha256 "1b70a5b03489d29f60fef18008a2164974234874faab48a4f47ec53d461d284a"
  revision 4

  head "https://github.com/devttys0/binwalk.git"

  bottle do
    sha256 "e737be262d3980463c1b587496df34295532a0548586b86c06077bb033f25d08" => :high_sierra
    sha256 "7ea9cbc89c26df4a50a13b882a077311c123b4b86a5343a5187c896d7a5d747e" => :sierra
    sha256 "d34e3ebcb6aa8fefd6d2807f5c47b5a7708200201a14bd66022cbdab20c9aeaa" => :el_capitan
    sha256 "aca94d246fb634eb189b1146bd999d6777996283fde07f1d943112af7cbff802" => :yosemite
  end

  option "with-capstone", "Enable disasm options via capstone"

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "p7zip"
  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "ssdeep"
  depends_on "xz"

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.10.2.tar.gz"
    sha256 "23a3befdf955db4d616f8bb77b324680a80a323e0c42a7e8d7388ef578d8ffa9"
  end

  resource "scipy" do
    url "https://downloads.sourceforge.net/project/scipy/scipy/0.16.1/scipy-0.16.1.tar.gz"
    sha256 "ecd1efbb1c038accb0516151d1e6679809c6010288765eb5da6051550bf52260"
  end

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/44/3f/2ae09118f1c890b98e7b87ff1ce3d3a36e8e72ddac74ddcf0bbe8f005210/capstone-3.0.5rc2.tar.gz"
    sha256 "c67a4e14d04b29126f6ae2a4aeb773acf96cc6705e1fa7bd9af1798fa928022a"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    res = %w[numpy scipy]
    res += %w[capstone] if build.with? "capstone"
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
