class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/45/5b/a818450c05e468dfc52478fce1a799d3303a501272de84c5934a4ddcee68/glances-4.4.1.tar.gz"
  sha256 "963cb195bd86646eda44ab4499f96f30a9cfe4260603d37f822835823dd5e094"
  license "LGPL-3.0-or-later"
  head "https://github.com/nicolargo/glances.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19f89543ec4047225680e53a8018babf7a16fc30f9a656742137e89da6d23008"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "577e3ce8b2701c1546510fba1baa15b24530d277ea25caadfcf6f0e2a6e35a41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cbd3ecd1df1785a3dd11e7749db600a32995bd9e8bb08d65e565b442f81a9283"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb239d6330ba3d73a63a42caf251e83cd0dcaaaac9ab19390eeb7cbb3f7be6c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e73cfe95b546545f93f7d6b295d0de24671b4a5b80e54d3e2fb02af7b66efd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5eb0bde53d4d2d1af2f290913664d46380300dc2e1ab978a8a92133472a5d6"
  end

  depends_on "rust" => :build # for annotated-docs
  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name:     "glances[containers,web]",
                exclude_packages: ["certifi", "pydantic"]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/d7/a6/dc46877b911e40c00d395771ea710d5e77b6de7bacd5fdcd78d70cc5a48f/annotated_doc-0.0.3.tar.gz"
    sha256 "e18370014c70187422c33e945053ff4c286f453a984eba84d0dbfa0c935adeda"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/91/9b/4a2ea29aeba62471211598dac5d96825bb49348fa07e906ea930394a83ce/docker-7.1.0.tar.gz"
    sha256 "ad8c70e6e3f8926cb8a92619b832b4ea5299e2831c14284663184e200546fa6c"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/8c/e3/77a2df0946703973b9905fd0cde6172c15e0781984320123b4f5079e7113/fastapi-0.121.0.tar.gz"
    sha256 "06663356a0b1ee93e875bbf05a31fb22314f5bed455afaaad2b2dad7f26e98fa"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "podman" do
    url "https://files.pythonhosted.org/packages/3b/36/070e7bf682ac0868450584df79198c178323e80f73b8fb9b6fec8bde0a65/podman-5.6.0.tar.gz"
    sha256 "cc5f7aa9562e30f992fc170a48da970a7132be60d8a2e2941e6c17bd0a0b35c9"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/5a/3e/837067b970c1d2ffa936c72f384a63fdec4e186b74da781e921354a94024/shtab-1.7.2.tar.gz"
    sha256 "8c16673ade76a2d42417f03e57acf239bfb5968e842204c17990cae357d07d6f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/de/1a/608df0b10b53b0beb96a37854ee05864d182ddd4b1156a22f1ad3860425a/starlette-0.49.3.tar.gz"
    sha256 "1c14546f299b5901a1ea0e34410575bc33bbd741377a10484a54445588d00284"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/cb/ce/f06b84e2697fef4688ca63bdb2fdf113ca0a3be33f94488f2cadb690b0cf/uvicorn-0.38.0.tar.gz"
    sha256 "fd97093bdd120a2609fc0d3afe931d4d4ad688b6e75f0f929fde1bc36fe0e91d"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin/"glances", "--print-completion", shells: [:bash, :zsh])
    # Workaround limited netifaces2 functionality on macOS
    # https://github.com/nicolargo/glances/issues/3219
    inreplace libexec/"share/doc/glances/glances.conf", /(port_default_gateway)=True/, "\\1=False" if OS.mac?
  end

  test do
    require "pty"
    PTY.spawn bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout" do |r, _w, pid|
      assert_match "timestamp", r.gets
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
