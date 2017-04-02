class AppscaleTools < Formula
  desc "Command-line tools for working with AppScale"
  homepage "https://github.com/AppScale/appscale-tools"
  url "https://github.com/AppScale/appscale-tools/archive/3.1.0.tar.gz"
  sha256 "8496e318fdebde9ff57be8b6789d9af3cc808aecbb509d19102d0d22d6e4fd09"
  head "https://github.com/AppScale/appscale-tools.git"

  bottle do
    cellar :any
    sha256 "5ba69f5ba46c8f72289dc58085cea0f7899638edd8a43219941d86aa26ebedd0" => :sierra
    sha256 "b2cb7cedfcf8270c862ee02ed7a59ddc799228483fd2440823ee8d93014e5ded" => :el_capitan
    sha256 "77ad0d79b6c30be6e328d78b5ee49472ca97632e9d2f9649d15c1933136e6551" => :yosemite
    sha256 "77f4d40774df641c52f26673a4fe4a5762eed19a17d3a39ba669c702503c7228" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"
  depends_on "ssh-copy-id"

  resource "termcolor" do
    url "https://pypi.python.org/packages/source/t/termcolor/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "SOAPpy" do
    url "https://pypi.python.org/packages/source/S/SOAPpy/SOAPpy-0.12.22.zip"
    sha256 "e70845906bb625144ae6a8df4534d66d84431ff8e21835d7b401ec6d8eb447a5"
  end

  # dependencies for soappy
  resource "wstools" do
    url "https://pypi.python.org/packages/source/w/wstools/wstools-0.4.3.tar.gz"
    sha256 "578b53e98bc8dadf5a55dfd1f559fd9b37a594609f1883f23e8646d2d30336f8"
  end
  resource "defusedxml" do
    url "https://pypi.python.org/packages/source/d/defusedxml/defusedxml-0.4.1.tar.gz"
    sha256 "cd551d5a518b745407635bb85116eb813818ecaf182e773c35b36239fc3f2478"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.39.0.tar.gz"
    sha256 "950c5bf36691df916b94ebc5679fed07f642030d39132454ec178800d5b6c58a"
  end

  resource "argparse" do
    url "https://pypi.python.org/packages/18/dd/e617cfc3f6210ae183374cd9f6a26b20514bbb5a792af97949c5aacddf0f/argparse-1.4.0.tar.gz"
    sha256 "62b089a55be1d8949cd2bc7e0df0bddb9e028faefc8c32038cc84862aefdd6e4"
  end

  resource "google-api-python-client" do
    url "https://pypi.python.org/packages/b5/b4/e7030ec96ce8eb5b00707d2530906c0c6389eb61af8f5a7ca4ee29d02643/google-api-python-client-1.5.1.tar.gz"
    sha256 "2fd69ea71497a7de01cee4c85a9a64a593458eba0c1fec8d8a24e34d1298fdbd"
  end

  # dependencies for google-api-python-client
  resource "oauth2client" do
    url "https://pypi.python.org/packages/7d/3d/fbafca0c10e400c80711a18365502b46c949f18d4c40d410ce059895bf2a/oauth2client-2.1.0.tar.gz"
    sha256 "d628c9c925815ce0aca159dd4c26f5bc013a8ef025574dd338314d98c1df4f72"
  end

  # dependencies for oauth2client
  resource "pyasn1" do
    url "https://pypi.python.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pyasn1-modules" do
    url "https://pypi.python.org/packages/source/p/pyasn1-modules/pyasn1-modules-0.0.8.tar.gz"
    sha256 "10561934f1829bcc455c7ecdcdacdb4be5ffd3696f26f468eb6eb41e107f3837"
  end

  resource "rsa" do
    url "https://pypi.python.org/packages/14/89/adf8b72371e37f3ca69c6cb8ab6319d009c4a24b04a31399e5bd77d9bb57/rsa-3.4.2.tar.gz"
    sha256 "25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "uritemplate" do
    url "https://pypi.python.org/packages/source/u/uritemplate/uritemplate-0.6.tar.gz"
    sha256 "a30e230aeb7ebedbcb5da9999a17fa8a30e512e6d5b06f73d47c6e03c8e357fd"
  end

  resource "httplib2" do
    url "https://pypi.python.org/packages/source/h/httplib2/httplib2-0.9.2.tar.gz"
    sha256 "c3aba1c9539711551f4d83e857b316b5134a1c4ddce98a875b7027be7dd6d988"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    site_packages = libexec/"lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", site_packages
    system "python", *Language::Python.setup_install_args(libexec)

    # appscale is a namespace package
    touch site_packages/"appscale/__init__.py"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"appscale", "help"
    system bin/"appscale", "init", "cloud"
  end
end
