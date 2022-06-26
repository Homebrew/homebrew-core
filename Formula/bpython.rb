class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/62/5c/4039865b7e21c792140ec36411b2999b8ffe98da0f0e79eebad779550868/bpython-0.22.1.tar.gz"
  sha256 "1fb1e0a52332579fc4e3dcf75e21796af67aae2be460179ecfcce9530a49a200"
  license "MIT"
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "943fae89e278f19412351539d35e992e5401de8d1a15675dd6ec942c58c67d07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "651508883e03d6502c7b8e2047c3bedfa0c2f863553d14f4748657879077b26b"
    sha256 cellar: :any_skip_relocation, monterey:       "8134659e82336cb7758bb7aee16c19107283b598cdf3c5fa03a493b0279283df"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fcf7d95f3cac1b2be748e68c99f4dc2d8a4abbc24d8a43675abe3a94f1f66f0"
    sha256 cellar: :any_skip_relocation, catalina:       "6022706aa857d60c9505e3ee5577628fd657c29cf92f8139c9e1075f9d68459f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ef397613d4c93a53f940f6027d0354d630116da8ff645c627d8257893e3b52"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/5c/f8/9f5e69a63a9243448350b44c87fae74588aa634979e6c0c501f26a4f6df7/blessings-1.7.tar.gz"
    sha256 "98e5854d805f50a5b58ac2333411b0482516a8210f23f43308baeb58d77c157d"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/b0/26/49fcac52193a33f024c36bc5a7f6d43fa3cecfecac307170a277b477aeba/curtsies-0.3.10.tar.gz"
    sha256 "11efbb153d9cb22223dd9a44041ea0c313b8411e246e7f684aa843f6aa9c1600"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/38/17/aadd0c6190dca91aa27c4d7e84d69d30fdf4966e7764247cdc395f8fe7d9/cwcwidth-0.1.5.tar.gz"
    sha256 "2c840e7d85f6de45c45986b416d79312c91882e1121b78d4c347e49c4238c09d"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/0c/10/754e21b5bea89d0e73f99d60c83754df7cc64db74f47d98ab187669ce341/greenlet-1.1.2.tar.gz"
    sha256 "e30f5ea4ae2346e62cedde8794a56858a67b878dd79f7df76a0767e356b1744a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
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

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
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
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}/bpython test.py")
  end
end
