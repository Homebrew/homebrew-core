class Httpie < Formula
  desc "User-friendly cURL replacement (command-line HTTP client)"
  homepage "http://httpie.org/"
  url "https://pypi.python.org/packages/70/91/47c81b650d3cf33e7e9e639c315903947466a1993053fe1ff019f555ca97/httpie-0.9.4.tar.gz"
  sha256 "0fc288a85d6c018c64bbc86dfcc9c7fad063e79816840dfa91e8d6c43654761e"

  head "https://github.com/jkbrzt/httpie.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "da9d2546404582dbc63b2143f71945321f4c3aacca794991f04f6e19f97a8493" => :el_capitan
    sha256 "6008745c55d89aaf134ab8bec17f2188746149e9904f5b25f6a96d3cb878f784" => :yosemite
    sha256 "3c3722eea4f74303af705f3bfb85c5c259f557af8689f36e6579a951f716b686" => :mavericks
  end

  depends_on :python3

  resource "pygments" do
    url "https://pypi.python.org/packages/b8/67/ab177979be1c81bc99c8d0592ef22d547e70bb4c6815c383286ed5dec504/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
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
