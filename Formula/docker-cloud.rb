class DockerCloud < Formula
  desc "SaaS to build, deploy and manage Docker-based applications"
  homepage "https://cloud.docker.com/"
  url "https://pypi.python.org/packages/0b/37/5dab4fa0559b0402736d5f23a2ef0b3252baccde45f1d571583cadd6e50b/docker-cloud-1.0.7.tar.gz"
  sha256 "249bd3928173276687feaea55c6a43e572947b5a592107ff6f4e245efc208f20"

  bottle do
    cellar :any
    sha256 "fe312aa207dbb5b909c2c1e0e050db5bf99689f5bbfd19e70e9008f26d47e83e" => :sierra
    sha256 "d02f6c0506a9286717ffe0acd93aaeeb2165508b41b511a138e6a048e2c0e6d8" => :el_capitan
    sha256 "88495980d8097204acd46432665dbaa5ed26b22f050a1ccbf63a535b47d61574" => :yosemite
    sha256 "d286644072acaf538aa0522753e934470462fb9285c04376697582ae0d3f4c11" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  resource "ago" do
    url "https://pypi.python.org/packages/source/a/ago/ago-0.0.6.tar.gz"
    sha256 "a64811a5a44cd3ba687d800986edf0f7a97859b8da75d3347c915b58b0869b44"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.10.tar.gz"
    sha256 "e713da45c96ca53a3a8b48140d4120374db622df16ab71759c9ceb5b8d46fe7c"
  end

  resource "python-dockercloud" do
    url "https://pypi.python.org/packages/ab/a4/845497d492e3222371632a7e43fcc504f6733db371755ee62beb3225a48e/python-dockercloud-1.0.8.tar.gz"
    sha256 "caf4d6423edaa8cddeedf2d7863e6f4b567f8d8feff9163444c18c6300014e21"
  end

  resource "backports.ssl-match-hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.4.0.2.tar.gz"
    sha256 "07410e7fb09aab7bdaf5e618de66c3dac84e2e3d628352814dc4c37de321d6ae"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.2.tar.gz"
    sha256 "3e95445c1db500a344079a47b171c45ef18f57d188dffdb0e4165c71bea8eb3d"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "tabulate" do
    url "https://pypi.python.org/packages/source/t/tabulate/tabulate-0.7.2.tar.gz"
    sha256 "532ccab8d9e4659a5f016d84814df86cc04763785e9de2739e890d956dc82d8f"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/a3/1e/b717151e29a70e8f212edae9aebb7812a8cae8477b52d9fe990dcaec9bbd/websocket_client-0.37.0.tar.gz"
    sha256 "678b246d816b94018af5297e72915160e2feb042e0cde1a9397f502ac3a52f41"
  end

  resource "future" do
    url "https://pypi.python.org/packages/source/f/future/future-0.15.0.tar.gz"
    sha256 "7f8ad46e287ac32e3dae78be41098c83d690b364142e0a5f11958c2b549420b0"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/docker-cloud", "container"
  end
end
