class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"

  stable do
    url "https://github.com/docker/compose/archive/1.7.1.tar.gz"
    sha256 "002be1c4cd22f73cee219e97e97dfd6b9ff7bfd8dbb40c0aa31c55e5e1a965e5"
  end

  bottle do
    cellar :any
    sha256 "55f2218a34358ca8ce2a8687922f1845b7e5c36b853f359e6bccaf90aa6f9f38" => :el_capitan
    sha256 "06d179914b9da6a93918e6812ae3bca47154819b134d2529b5b8085473b218ce" => :yosemite
    sha256 "e93604184ad051e6705eb040bd0e64625b9be31bf2fc97bb4161ffc73bc1f3e6" => :mavericks
  end

  head do
    url "https://github.com/docker/compose.git"
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  # It's possible that the user wants to manually install Docker and Machine,
  # for example, they want to compile Docker manually
  depends_on "docker" => :recommended
  depends_on "docker-machine" => :recommended

  resource "setuptools" do
    url "https://pypi.python.org/packages/source/s/setuptools/setuptools-20.7.0.tar.gz"
    sha256 "505cdf282c5f6e3a056e79f0244b8945f3632257bba8469386c6b9b396400233"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "cached-property" do
    url "https://pypi.python.org/packages/source/c/cached-property/cached-property-1.3.0.tar.gz"
    sha256 "458e78b1c7286ece887d92c9bee829da85717994c5e3ddd253a40467f488bc81"
  end

  resource "ipaddress" do
    url "https://pypi.python.org/packages/cd/c5/bd44885274379121507870d4abfe7ba908326cf7bfd50a48d9d6ae091c0d/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "docker-py" do
    url "https://pypi.python.org/packages/d9/af/4c4edd438a1d132a30c7877d929841a6b8e843ee281f41d91500ad7fac65/docker-py-1.8.1.tar.gz"
    sha256 "4f47a05e677472b5e022be1ab1dfd91b473ab3fc14a6b71337042ac2caaafa0b"
  end

  resource "dockerpty" do
    url "https://pypi.python.org/packages/source/d/dockerpty/dockerpty-0.4.1.tar.gz"
    sha256 "69a9d69d573a0daa31bcd1c0774eeed5c15c295fe719c61aca550ed1393156ce"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "enum34" do
    url "https://pypi.python.org/packages/source/e/enum34/enum34-1.1.2.tar.gz"
    sha256 "2475d7fcddf5951e92ff546972758802de5260bf409319a9f1934e6bbc8b1dc7"
  end

  resource "functools32" do
    url "https://pypi.python.org/packages/source/f/functools32/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  resource "jsonschema" do
    url "https://pypi.python.org/packages/source/j/jsonschema/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "py2-ipaddress" do
    url "https://pypi.python.org/packages/source/p/py2-ipaddress/py2-ipaddress-3.4.1.tar.gz"
    sha256 "6d7bf02ac2590764691bf50ac213e966bc885ed37c02606513dcac484190564b"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "texttable" do
    url "https://pypi.python.org/packages/source/t/texttable/texttable-0.8.4.tar.gz"
    sha256 "8587b61cb6c6022d0eb79e56e59825df4353f0f33099b4ae3bcfe8d41bd1702e"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/source/w/websocket-client/websocket_client-0.37.0.tar.gz"
    sha256 "678b246d816b94018af5297e72915160e2feb042e0cde1a9397f502ac3a52f41"
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

    bash_completion.install "contrib/completion/bash/docker-compose"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match /#{version}/, shell_output(bin/"docker-compose --version")
  end
end
