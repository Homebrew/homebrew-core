class PythonMutagen < Formula
  desc "Python module for handling audio metadata"
  homepage "https://mutagen.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
  sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c25945066d4cee64f3f07e0ee27efee57561c28e615082710a51c747d783b40d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d1784d4b134151cfce667ced82387a5b849015883f43433899da2ba5e40868b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7249d577993d8359e12dfc0e5c6f40e990e82a9984eb46430d77a185f64951d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "48895044a628393894de0e2ea2200618ded8bf481fd17c89fdaefd220774eead"
    sha256 cellar: :any_skip_relocation, ventura:        "88301d2f14b5d11f8eba199461a10281b2fffda2d68095208f202ea530b7cb76"
    sha256 cellar: :any_skip_relocation, monterey:       "eb331104be1b280fe2dfbcb74208331fa14ff53e36422ea523999929862fbf7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e640c921f3ea814eecd2e8690d4f3f467836d9034ced68251699ea76c192de4b"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  def caveats
    <<~EOS
      To run command line tools, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from mutagen.id3 import ID3, TIT2"
    end
  end
end
