class Httpie < Formula
  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "https://httpie.org/"
  url "https://pypi.python.org/packages/be/52/d85e9d18138cb0bbb396d52d53219f294fcf065eb543a65a4b38a3a0e03c/httpie-0.9.6.tar.gz"
  sha256 "a64b90f845544b654495fa9268431dfb74c14c3a855b52937517a70c812f90b1"

  head "https://github.com/jkbrzt/httpie.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5da06ad61be5af62602b3e66baffaa2fa7c1be286c1315abbf8c1b4d43bc95f" => :sierra
    sha256 "c24867af6ad2263b171e2035923e695ae002c19a45bf05d3568a571c158d4196" => :el_capitan
    sha256 "9f5462576937e26353a4d4ab9a71a97afaa90d7deeede2e961660fa12dddc5c8" => :yosemite
    sha256 "3bcdaf0f9500ffe553706285795d0ad1439073c252c915ff92ccd77095fb5c0e" => :mavericks
  end

  depends_on :python3

  resource "pygments" do
    url "https://pypi.python.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/8d/66/649f861f980c0a168dd4cccc4dd0ed8fa5bd6c1bed3bea9a286434632771/requests-2.11.0.tar.gz"
    sha256 "b2ff053e93ef11ea08b0e596a1618487c4e4c5f1006d7a1706e3671c57dea385"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{pyver}/site-packages"
    %w[pygments requests].each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    raw_url = "https://raw.githubusercontent.com/Homebrew/homebrew-core/master/Formula/httpie.rb"
    assert_match "PYTHONPATH", shell_output("#{bin}/http --ignore-stdin #{raw_url}")
  end
end
