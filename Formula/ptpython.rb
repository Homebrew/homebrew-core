class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/15/c0/2174901413124288fc5217286f05aede748eea2a2b6e0894a165bcd14846/ptpython-3.0.19.tar.gz"
  sha256 "b3d41ce7c2ce0e7e55051347eae400fc56b9b42b1c4a9db25b19ccf6195bfc12"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e9eb2acdb2931c0846ba568b84ae729ce1230399fd8f0b30b6cf902044b32e6c"
    sha256 cellar: :any_skip_relocation, big_sur:       "0bd5e4b89dd1b126ed4db854a028f1fa0cd0003edc635454bf7fd5d29cb4b4ea"
    sha256 cellar: :any_skip_relocation, catalina:      "730e0399443d57b8fa4f4582373e88f12ef6e5aafd6eb46155503b87ff851584"
    sha256 cellar: :any_skip_relocation, mojave:        "6cf1284fd769db74518cf18ea2c802dfccfa5ff356f58a6cfe74895f2bd8f365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff7b5cc4b45f214eabddc4f4328ffe836e9f20d4517a1a47eecb92da92d0dc85"
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
    url "https://files.pythonhosted.org/packages/88/4b/2c0f9e2b52297bdeede91c8917c51575b125006da5d0485521fa2b1e0b75/prompt_toolkit-3.0.19.tar.gz"
    sha256 "08360ee3a3148bdb5163621709ee322ec34fc4375099afa4bbf751e9b7b7fa4f"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
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
