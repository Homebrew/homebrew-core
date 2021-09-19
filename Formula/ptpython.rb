class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/00/df/223017f2565336078c872f700ebe1c893a051e4d7b472fd0b68289ab3acb/ptpython-3.0.20.tar.gz"
  sha256 "eafd4ced27ca5dc370881d4358d1ab5041b32d88d31af8e3c24167fe4af64ed6"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d7df4ae05100b54702e66baf39bcc38a0060e1cb84be0978881516f34fe88b9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "429e329b9328276d88f08e0cd4e6e9dfae89a50e2b8716cff02534b41a016560"
    sha256 cellar: :any_skip_relocation, catalina:      "f43630b40c73ebf63850508677de0bdc768156e2f2df1c81477ddf4693a4abd5"
    sha256 cellar: :any_skip_relocation, mojave:        "918f17e34caed247c6d2cea471198997a02afb68bb9f73b7221a8061a6a1fdb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bf23b96b379d267d6d343eac9ec6d6377d5eaaf4afd505de242ae4719582927"
  end

  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/ac/11/5c542bf206efbae974294a61febc61e09d74cb5d90d8488793909db92537/jedi-0.18.0.tar.gz"
    sha256 "92550a404bad8afed881a137ec9a461fed49eca661414be45059329614ed0707"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/5e/61/d119e2683138a934550e47fc8ec023eb7f11b194883e9085dca3af5d4951/parso-0.8.2.tar.gz"
    sha256 "12b83492c6239ce32ff5eed6d3639d6a536170723c6f3f1506869f1ace413398"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/b4/56/9ab5868f34ab2657fba7e2192f41316252ab04edbbeb2a8583759960a1a7/prompt_toolkit-3.0.20.tar.gz"
    sha256 "eb71d5a6b72ce6db177af4a7d4d7085b99756bf656d98ffcc4fecd36850eea6c"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
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
