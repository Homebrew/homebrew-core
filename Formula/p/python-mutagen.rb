class PythonMutagen < Formula
  desc "Python module for handling audio metadata"
  homepage "https://mutagen.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
  sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4ca7b524e87bbd317ff54527d11230e660719f03f04af086177611badba69ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a80f0c2864bdf226caa75187fe7119314b642e569fbf16a9d1c949bbbc551caf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "612f566eec75785bf93158d27c3fbaabe6d50a0bc31cc00d334592c07fb5706b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3feea8f29301649f4c0c036ec50319280e36bc6811ab16d1b9e41021ae7d89d"
    sha256 cellar: :any_skip_relocation, ventura:        "d07660c0bb928ce8d594d88a5d5560cb8bb91fcdc363f1cd423235f3d5c787ee"
    sha256 cellar: :any_skip_relocation, monterey:       "4d4aa9c8e1f00a6783546df150d6c728ff703896126c1cee44a55a5956e39314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed9b410dd58731e2633a5ef5ae88ee0680e5af16a0dbaff038057a62dab490c6"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
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

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from mutagen.id3 import ID3, TIT2"
    end
  end
end
