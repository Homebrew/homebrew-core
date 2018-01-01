class DockerCloud < Formula
  desc "SaaS to build, deploy and manage Docker-based applications"
  homepage "https://cloud.docker.com/"
  url "https://files.pythonhosted.org/packages/78/75/511a967ccabff691b57f97bde04cff29af2f493c6ec91a5f57c42badc3b0/docker-cloud-1.0.9.tar.gz"
  sha256 "dcddda43b2e9acbadcc3b658a61a35a413a5e623513c72c35c990e6ed15b4f8e"

  bottle do
    cellar :any
    sha256 "809594637760e2118111760fee5b298ee528dd862f845055a8f0e2a03aee10b5" => :high_sierra
    sha256 "b5337ce18f9053667a61f4873e3d1e8b7f910b0a668505c853531be48b95428a" => :sierra
    sha256 "90b1feb11ccb54a1481a2c23df1c70762b346d0907b7f873296b70fb6774b763" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  resource "ago" do
    url "https://files.pythonhosted.org/packages/83/1a/17e89f0be2cf69e17fbc96012bd6a2bf6d88a8fd3ac79854cc7007971943/ago-0.0.9.tar.gz"
    sha256 "18ab19c41374e6eb55fd9b9d19e988c6dd7033818bb3cd7600269475ba657601"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "python-dockercloud" do
    url "https://files.pythonhosted.org/packages/97/66/776e420e7db5d3c20921e88f1cb333737ace862c8d02234367b32d969525/python-dockercloud-1.0.12.tar.gz"
    sha256 "83f4c9d8b2a9dc5abb1404d1bf673d6562866db2dad7765d0deffd8622f924a0"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/72/46/4abc3f5aaf7bf16a52206bb0c68677a26c216c1e6625c78c5aef695b5359/requests-2.14.2.tar.gz"
    sha256 "a274abba399a23e8713ffd2b5706535ae280ebe2b8069ee6a941cb089440d153"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/1c/a1/3367581782ce79b727954f7aa5d29e6a439dc2490a9ac0e7ea0a7115435d/tabulate-0.7.7.tar.gz"
    sha256 "83a0b8e17c09f012090a50e1e97ae897300a72b35e0c86c0b53d3bd2ae86d8c6"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/a7/2b/0039154583cb0489c8e18313aa91ccd140ada103289c5c5d31d80fd6d186/websocket_client-0.40.0.tar.gz"
    sha256 "40ac14a0c54e14d22809a5c8d553de5a2ae45de3c60105fae53bcb281b3fe6fb"
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
