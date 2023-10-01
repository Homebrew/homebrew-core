class PythonLxml < Formula
  desc "Pythonic binding for the libxml2 and libxslt libraries"
  homepage "https://github.com/lxml/lxml"
  url "https://files.pythonhosted.org/packages/30/39/7305428d1c4f28282a4f5bdbef24e0f905d351f34cf351ceb131f5cddf78/lxml-4.9.3.tar.gz"
  sha256 "48628bd53a426c9eb9bc066a923acaa0878d1e86129fd5359aee99285f4eed9c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de03c77c8875a9d6e3be2c2fb1083d6d038fa5f9721fc734bf89b7677dd643aa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5521a0623aeb08d39b0ea5554f9678a8afba93023ae0db4fcdfd11cc0bdc28ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b42a0e7770a74372326f20a1053de97998b58d3f41468cf61ebe71117a29a02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd48b0b9528659465d5e38eb1f4b4b1632f285ec8861240059c49489ef938e30"
    sha256 cellar: :any_skip_relocation, sonoma:         "b2fa0dc4bcae662a241ade042a0baaa93ad9e97763918d8be39c9ade39170ef4"
    sha256 cellar: :any_skip_relocation, ventura:        "eb23c25272811f76bbafae511cf6719d5e965328c9f93f76ea01245b1ae71b89"
    sha256 cellar: :any_skip_relocation, monterey:       "c3558c84308ef907e2e000b974e35afbef07e4eb272f10ed27aea186cd030a8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7994ef91def9ff96c3146d270ab6224adb45959afd8c6e33152dceff8ebab1f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ea4c4dabb7b024ff08a7ff531de53948e73d06b79b0da31ea3281c052106574"
  end

  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.9" => [:build, :test]

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

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
      system python_exe, "-c", "import lxml"
    end
  end
end
