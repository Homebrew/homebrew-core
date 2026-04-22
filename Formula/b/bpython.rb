class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/44/29/cd80e9108a6fc6a925ffb915f8f69198a2bb2388e39167a41d743ac2a8f4/bpython-0.26.tar.gz"
  sha256 "f79083e1e3723be9b49c9994ad1dd3a19ccb4d0d4f9a6f5b3a73bef8bc327433"
  license "MIT"
  revision 4
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6e6d1c65644a6950494960fa6a7f46fca7cc5f0bbed89cce20728a4b8f6dd34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16e1b2bca7b2c3f1b2a0b90b34cd9cf7d33d2d99e80ea498e1b9aedd655d75ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c06d8dc99cf3e925339a6c187563ac330860b86eac3aeba98c142802ae58df5"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a9c7ad94255bdcc9ab9c73fd4070bba9deec65966f124fe1134a00a72ece9f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe0beaf48cfe30c5910321281d81c647bb23ad1ff2cee71919f60ea2928d9309"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e7a185beb1aca1c73e399d60ac82c06f6d439cd3e75163ea898032a3c5cba27"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/0c/ec/67c46675f26223fa9972276f4f0e616773a75a79ec25fafc62f4d4f6b770/blessed-1.37.0.tar.gz"
    sha256 "36da5ff5779c1b15d4dfa8cd583ea3b05a0a31e1db4bd5af81f89c774b3e9815"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/7b/60/e3bec1881450851b087e301bedc3daa9377a4d45f1c26aa90b0b235e38aa/charset_normalizer-3.4.6.tar.gz"
    sha256 "1ae6b62897110aa7c79ea2f5dd38d1abca6db663687c0b1ad9aed6f6bae3d9d6"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/d1/18/5741cb42624089a815520d5b65c39c3e59673a77fd1fab6ad65bdebf2f91/curtsies-0.4.3.tar.gz"
    sha256 "102a0ffbf952124f1be222fd6989da4ec7cce04e49f613009e5f54ad37618825"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/86/5f/f5c3d1b4e9c8c541406ca0654efa1bfaa05414f8e7d1c14bc6e3fd0752f8/cwcwidth-0.1.12.tar.gz"
    sha256 "bfc16531d1246dd2558eb9b3a63aa37a9978672b956860dc5426da2343ebf366"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/a3/51/1664f6b78fc6ebbd98019a1fd730e83fa78f2db7058f72b1463d3612b8db/greenlet-3.3.2.tar.gz"
    sha256 "2eaf067fc6d886931c7962e8c6bede15d2f01965560f3359b27c80bde2d151f2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/34/64/8860370b167a9721e8956ae116825caff829224fbca0ca6e7bf8ddef8430/requests-2.33.0.tar.gz"
    sha256 "c7ebc5e8b0f21837386ad0e1c8fe8b829fa5f544d8df3b2253bff14ef29d7652"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/35/a2/8e3becb46433538a38726c948d3399905a4c7cabd0df578ede5dc51f0ec2/wcwidth-0.6.0.tar.gz"
    sha256 "cdc4e4262d6ef9a1a57e018384cbeb1208d8abbc64176027e2c2455c81313159"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}/bpython test.py")
  end
end
