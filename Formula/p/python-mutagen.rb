class PythonMutagen < Formula
  desc "Python module for handling audio metadata"
  homepage "https://mutagen.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/81/e6/64bc71b74eef4b68e61eb921dcf72dabd9e4ec4af1e11891bbd312ccbb77/mutagen-1.47.0.tar.gz"
  sha256 "719fadef0a978c31b4cf3c956261b3c58b6948b32023078a2117b1de09f0fc99"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5a35e0ce729d07b6bc8416431ccfcce4dd48650b45e8abec95ba49a623f5c70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a62ac701271cf2ecad5ad641b0b30a1e40a6a3ad985df9ce17dc438082ebba26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e752eafe197340eaff6cf06d448a17eae01e7911c89fbf16294c7f3bcb04003c"
    sha256 cellar: :any_skip_relocation, ventura:        "bc2a20e89cb0b74241bcd98d030b8a118507b75a1f04973c6558ec1d4e7a57f0"
    sha256 cellar: :any_skip_relocation, monterey:       "13e2ee719329a63fa4cc4f40995624a61650366383c0dce545c3b56c5a625446"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5b0b8b635e264eb58cd824c53cd535ffc8eaa16a69d3d1159247f1cac4c4d2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39cfb9e9d27a7ca07dc9dd542fedbe8aed6ba481d84491b4f1faba08ee5c35aa"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

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
