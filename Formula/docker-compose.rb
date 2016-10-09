class DockerCompose < Formula
  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.8.1.tar.gz"
  sha256 "ee6534e2e420bdcd9beb5884f5dabd9f6ee832e43b3ad226f8b74f547bdd7fcd"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "eb49e778faf43241a849aa2a78e636db878b6f0a9e8859575ecc408f22f607eb" => :sierra
    sha256 "3e12de5894e366b83724ef2ecc3a423517f97c5d9f254b9ad7bbc3d5078be15f" => :el_capitan
    sha256 "25583cb04ec0d5c9f512962759c5c650063a18721222094c10e7f5edfa5b86b7" => :yosemite
    sha256 "48811db093fa06380fe6244110ede581feeb939b9e43c907d2de0f18cbaa5dfc" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  # It's possible that the user wants to manually install Docker and Machine,
  # for example, they want to compile Docker manually
  depends_on "docker" => :recommended
  depends_on "docker-machine" => :recommended

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/9c/25/fa63da717a694ecf3bdb27f438450f535cdcabd77a955b5b05113f1abd11/setuptools-25.1.1.tar.gz"
    sha256 "eac02ddb04d1c7af94542f65d34e56c69c2be843688126d3a38916a3b1a999a0"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/ae/02/09b905981aefb99c97ad53ac1cc0a90f02c1457a549eae98d87e8e6f2d7e/cached-property-1.3.0.tar.gz"
    sha256 "458e78b1c7286ece887d92c9bee829da85717994c5e3ddd253a40467f488bc81"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/d7/32/1e6be8c9ebc7d02fe74cb1a050008bc9d7e2eb9219f5d5e257648166e275/docker-py-1.9.0.tar.gz"
    sha256 "6dc6b914a745786d97817bf35bfc1559834c08517c119f846acdfda9cc7f6d7e"
  end

  resource "dockerpty" do
    url "https://files.pythonhosted.org/packages/8d/ee/e9ecce4c32204a6738e0a5d5883d3413794d7498fe8b06f44becc028d3ba/dockerpty-0.4.1.tar.gz"
    sha256 "69a9d69d573a0daa31bcd1c0774eeed5c15c295fe719c61aca550ed1393156ce"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "functools32" do
    url "https://files.pythonhosted.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/cd/c5/bd44885274379121507870d4abfe7ba908326cf7bfd50a48d9d6ae091c0d/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/0a/00/8cc925deac3a87046a4148d7846b571cf433515872b5430de4cd9dea83cb/requests-2.7.0.tar.gz"
    sha256 "398a3db6d61899d25fd4a06c6ca12051b0ce171d705decd7ed5511517b4bb93d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/f5/5e/47cbc50187ca719a39ce4838182c6126487ca62ddd299bc34cafb94260fe/texttable-0.8.4.tar.gz"
    sha256 "8587b61cb6c6022d0eb79e56e59825df4353f0f33099b4ae3bcfe8d41bd1702e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/a3/1e/b717151e29a70e8f212edae9aebb7812a8cae8477b52d9fe990dcaec9bbd/websocket_client-0.37.0.tar.gz"
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
    assert_match version.to_s, shell_output(bin/"docker-compose --version")
  end
end
