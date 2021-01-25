class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/ea/10/f241fc42493e54aa1ea2c54ce8f93c9fe22c7e6b755a679a40d3ba4b1b2d/ptpython-3.0.12.tar.gz"
  sha256 "cb110955be0ad0eb197f3f07f5ecdce44bd7467b03d519f4cc2b856c4782bf5d"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b73e2364981817c539d7d2aecd484c6ae483f0e0db589116d285a745d924e1ff" => :big_sur
    sha256 "c0e5044ba193b485077bfb3b403683a550e5afc1ded5b684f59ce82ab87a6d03" => :arm64_big_sur
    sha256 "30535afc008852b70a08697b57ca6ec88f9b15c8fbda11334e232684f040be01" => :catalina
    sha256 "6dd51fcc90beb26a28b7b512bb65347d3c6651f0d6113663b459199233731bb5" => :mojave
  end

  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "black" do
    url "https://files.pythonhosted.org/packages/dc/7b/5a6bbe89de849f28d7c109f5ea87b65afa5124ad615f3419e71beb29dc96/black-20.8b1.tar.gz"
    sha256 "1c02557aa099101b9d21496f8a914e9ed2222ef70336404eeeac8edba836fbea"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/ac/11/5c542bf206efbae974294a61febc61e09d74cb5d90d8488793909db92537/jedi-0.18.0.tar.gz"
    sha256 "92550a404bad8afed881a137ec9a461fed49eca661414be45059329614ed0707"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/63/60/0582ce2eaced55f65a4406fc97beba256de4b7a95a0034c6576458c6519f/mypy_extensions-0.4.3.tar.gz"
    sha256 "2d82818f5bb3e369420cb3c4060a7970edba416647068eb4c5343488a6c604a8"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/5d/62/31ce4b24055558771af3498266852e1a89b4ca43ecec251b16122da32dbd/parso-0.8.1.tar.gz"
    sha256 "8519430ad07087d4c997fda3a7918f7cfa27cb58972a8c89c2a0295a1c940e9e"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/b7/64/e097eea8dcd2b2f7df6e4425fc98e7494e37b1a6e149603c31d327080a05/pathspec-0.8.1.tar.gz"
    sha256 "86379d6b86d75816baba717e64b1a3a3469deb93bb76d613c9ce79edc5cb68fd"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/b1/46/4eb242362c43cf033b4ec4d7205612c46c9f904a8984cdfdb64d35476175/prompt_toolkit-3.0.14.tar.gz"
    sha256 "7e966747c18ececaec785699626b771c1ba8344c8d31759a1915d6b12fad6525"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e1/86/8059180e8217299079d8719c6e23d674aadaba0b1939e25e0cc15dcf075b/Pygments-2.7.4.tar.gz"
    sha256 "df49d09b498e83c1a73128295860250b0b7edd4c723a32e9bc0d295c7c2ec337"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/2e/e4/3447fed9ab29944333f48730ecff4dca92f0868c5b188d6ab2b2078e32c2/regex-2020.11.13.tar.gz"
    sha256 "83d6b356e116ca119db8e7c6fc2983289d87b27b3fac238cfe5dca529d884562"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/36/8c/efd8ffe7d242cd389632a11cbc6ce596de49b46ece22760a67b742534368/typed_ast-1.4.2.tar.gz"
    sha256 "9fc0b3cb5d1720e7141d103cf4819aea239f7d136acf9ee4a69b047b7986175a"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resources
    venv.pip_install buildpath

    # Make the Homebrew site-packages available in the interpreter environment
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.prepend_path "PYTHONPATH", HOMEBREW_PREFIX/"lib/python#{xy}/site-packages"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    combined_pythonpath = ENV["PYTHONPATH"] + "${PYTHONPATH:+:}$PYTHONPATH"
    %w[ptipython ptipython3 ptipython3.9 ptpython ptpython3 ptpython3.9].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin/#{cmd}", PYTHONPATH: combined_pythonpath
    end
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}/ptpython test.py").chomp
  end
end
