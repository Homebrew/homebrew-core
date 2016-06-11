class DockerCloud < Formula
  desc "SaaS to build, deploy and manage Docker-based applications"
  homepage "https://cloud.docker.com/"
  url "https://pypi.python.org/packages/3f/c9/3cd5eee6776e9c0b8866f39c0b63603c8dc8f8560825394677af350fbec7/docker-cloud-1.0.4.tar.gz"
  sha256 "f11aa181a3f8ceac493394d95c1d566d244ade8d905de737780ae3326aab3d83"

  bottle do
    cellar :any
    sha256 "07075cfa40956fd8601da48a3f4b7a7dd7b0a92b5e725d037ec771b3d3bbc066" => :el_capitan
    sha256 "1736c04f1e5eb84ab0337219c3266a8ae634fab48c7cae85860ca6c28a55e618" => :yosemite
    sha256 "6f22903be4e1f3ba4ea7c24d9871ce9ed35e408dd392260e0252d1bcdf5e9ef6" => :mavericks
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
    url "https://pypi.python.org/packages/15/1e/d8bade5c51d458748e68783a78fc9f0f2664f2b6bb937e75ec2bb4e4c3da/python-dockercloud-1.0.5.tar.gz"
    sha256 "b256265caa51593535d985657d6bab3027142c1ed66454e693a5155b33bfc90a"
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
