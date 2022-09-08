class Iredis < Formula
  include Language::Python::Virtualenv

  desc "Terminal Client for Redis with AutoCompletion and Syntax Highlighting"
  homepage "https://iredis.io"
  url "https://files.pythonhosted.org/packages/8a/a6/80b049052a354b8b922f297634aaea2ca0f9dab866dae5397d39e91f3d9f/iredis-1.12.1.tar.gz"
  sha256 "9cbc2ee3bc15e50aa0b62ca237d6db2b38e565d81de90b792a30658a9c115b54"
  license "BSD-3-Clause"
  head "https://github.com/laixintao/iredis.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c649fd208b9a8fd858862fa586e21d17cf090a7abb08cdcf6d61178356a4a21"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b26af4935dd625e0fddb7c0ee28caeb57e5f69209dbcf1173bbeb7674f7a6cf4"
    sha256 cellar: :any_skip_relocation, monterey:       "79ed223fbcdf250bb10158a4d8194a417911c482973fbca577bb9a792e800f58"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8eddf0578de74dc261157ec9aedfbcca66356ee9e6ff7b9a49fa6b45cce0630"
    sha256 cellar: :any_skip_relocation, catalina:       "d3372d837b6e7a983849cc2ea6fff3edbc84890fbdbb3fdf947c10265de639ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "971d3d8d64caedfa179d59ca99612d0b4fca2f7e5d907ba7f37d99ef25daa17c"
  end

  depends_on "poetry" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/38/b6/bc58f9261c70abb5fd670f9ad5d84445a402b4b473f308c5bf699cd379e0/importlib_resources-5.9.0.tar.gz"
    sha256 "5481e97fb45af8dcf2f798952625591c58fe599d0735d86b10f54de086a61681"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/cd/9b/0f98334812f548a5ee4399b76e33752a74fc7bb976f5efb34d962f03d585/mistune-2.0.4.tar.gz"
    sha256 "9ee0a66053e2267aba772c71e06891fa8f1af6d4b01d5e84e267b4570d4d9808"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/db/15/6e89ae7cde7907118769ed3d2481566d05b5fd362724025198bb95faf599/pendulum-2.1.2.tar.gz"
    sha256 "b06a0ca1bfe41c990bbf0c029f0b6501a7f2ec4e38bfec730712015e8860f207"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c5/7e/71693dc21d20464e4cd7c600f2d8fad1159601a42ed55566500272fe69b5/prompt_toolkit-3.0.30.tar.gz"
    sha256 "859b283c50bde45f5f97829f77a4674d1c1fcd88539364f1b28a37805cfd89c0"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/59/0f/eb10576eb73b5857bc22610cdfc59e424ced4004fe7132c8f2af2cc168d3/Pygments-2.12.0.tar.gz"
    sha256 "5eb116118f9612ff1ee89ac96437bb6b49e8f04d8a13b514ba26f620208e26eb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytzdata" do
    url "https://files.pythonhosted.org/packages/67/62/4c25435a7c2f9c7aef6800862d6c227fc4cd81e9f0beebc5549a49c8ed53/pytzdata-2020.1.tar.gz"
    sha256 "3efa13b335a00a8de1d345ae41ec78dd11c9f8807f522d39850f2dd828681540"
  end

  resource "redis" do
    url "https://files.pythonhosted.org/packages/b3/17/1e567ff78c83854e16b98694411fe6e08c3426af866ad11397cddceb80d3/redis-3.5.3.tar.gz"
    sha256 "0e7e0cfca8660dea8b7d5cd8c4f6c5e29e11f31158c0b0ae91a397f00e5a05a2"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/25/9d/0acbed6e4a4be4fc99148f275488580968f44ddb5e69b8ceb53fc9df55a0/wcwidth-0.1.9.tar.gz"
    sha256 "ee73862862a156bf77ff92b09034fc4825dd3af9cf81bc5b360668d425f3c5f1"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")

    # Install pytzdata using brewed poetry to avoid build dependency on Rust.
    resource("pytzdata").stage do
      system Formula["poetry"].opt_bin/"poetry", "build", "--format", "wheel", "--verbose", "--no-interaction"
      venv.pip_install_and_link Dir["dist/pytzdata-*.whl"].first
    end

    venv.pip_install resources.reject { |r| r.name == "pytzdata" }
    venv.pip_install_and_link buildpath
  end

  test do
    port = free_port
    output = shell_output("#{bin}/iredis -p #{port} info 2>&1", 1)
    assert_match "Connection refused", output
  end
end
