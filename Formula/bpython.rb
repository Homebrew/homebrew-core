class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/8f/34/7bdeba9999d2dfe5c0682291966bfa7edcedf2859885fa0037b8a38d0878/bpython-0.21.tar.gz"
  sha256 "88aa9b89974f6a7726499a2608fa7ded216d84c69e78114ab2ef996a45709487"
  license "MIT"
  revision 1
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0110e31bc799b06c75445bc78b53313abca5f12bfe7fe9c602a18275ea44af75"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ebf72000020bb9a3093c81bcb2a903b43d034f8ab241623f10f788e4017acf3"
    sha256 cellar: :any_skip_relocation, catalina:      "5c7a186a5a17c8a6b309290986f567beb972801795dd05e81805ea532c1ecbc9"
    sha256 cellar: :any_skip_relocation, mojave:        "c4ad1b0670cb800236092f31acbacf7fa66d1a553968a91411cc25223fa939b4"
  end

  depends_on "python@3.10"

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/5c/f8/9f5e69a63a9243448350b44c87fae74588aa634979e6c0c501f26a4f6df7/blessings-1.7.tar.gz"
    sha256 "98e5854d805f50a5b58ac2333411b0482516a8210f23f43308baeb58d77c157d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/eb/7f/a6c278746ddbd7094b019b08d1b2187101b1f596f35f81dc27f57d8fcf7c/charset-normalizer-2.0.6.tar.gz"
    sha256 "5ec46d183433dcbd0ab716f2d7f29d8dee50505b3fdb40c6b985c7c4f5a3591f"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/b0/26/49fcac52193a33f024c36bc5a7f6d43fa3cecfecac307170a277b477aeba/curtsies-0.3.10.tar.gz"
    sha256 "11efbb153d9cb22223dd9a44041ea0c313b8411e246e7f684aa843f6aa9c1600"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/ec/dd/07aee69281914e20ad3e703579caf28658230602efeaecca973e801deb60/cwcwidth-0.1.4.tar.gz"
    sha256 "482a937891a6918667436e0a7041aab576c26e4bcbcdddd178ef79362fbcf9ab"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/0c/10/754e21b5bea89d0e73f99d60c83754df7cc64db74f47d98ab187669ce341/greenlet-1.1.2.tar.gz"
    sha256 "e30f5ea4ae2346e62cedde8794a56858a67b878dd79f7df76a0767e356b1744a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/6f/2e/2251b5ae2f003d865beef79c8fcd517e907ed6a69f58c32403cec3eba9b2/pyxdg-0.27.tar.gz"
    sha256 "80bd93aae5ed82435f20462ea0208fb198d8eec262e831ee06ce9ddb6b91c5a5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.10"].opt_bin/"python3")
    venv.pip_install resources
    venv.pip_install buildpath

    # Make the Homebrew site-packages available in the interpreter environment
    xy = Language::Python.major_minor_version Formula["python@3.10"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    combined_pythonpath = ENV["PYTHONPATH"] + "${PYTHONPATH:+:}$PYTHONPATH"
    %w[bpdb bpython].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin/#{cmd}", PYTHONPATH: combined_pythonpath
    end
  end

  test do
    require "pty"
    (testpath/"test.py").write "print(2+2)\n"
    PTY.spawn(bin/"bpython", "test.py") do |r, _w, _pid|
      assert_equal "4", r.read.chomp
    end
  end
end
