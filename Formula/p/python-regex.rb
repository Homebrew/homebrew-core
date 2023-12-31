class PythonRegex < Formula
  desc "Alternative regular expression module, to replace re"
  homepage "https://github.com/mrabarnett/mrab-regex"
  url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
  sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aec834b4d3ca793325e967b44fa78558803520e2bdbed366003a07dfcdbcea00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfdcc8124866790f04d4f9f8b89fbfaaa0ce9b1b308722f83c4f16b4ef0e69b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeb6c65107f377ad71ad123ac4c6c3944859ed815665598b5f6fa0d65aeea273"
    sha256 cellar: :any_skip_relocation, sonoma:         "7fabb7b7b42b77358e1866ccd427df8037495936b86be361ac3308cf97cc29ce"
    sha256 cellar: :any_skip_relocation, ventura:        "b275bca5a314300b85f795456bc8ff63162aa9b1ef1c337a09cdc65205ce2621"
    sha256 cellar: :any_skip_relocation, monterey:       "f796a093faa0cc3c4592df54167a3f1f2e6ba5c7f300aee160180eaf46a800f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ca1a818f876ae2ae7f059f4bb1ae65fbabaa033de650ab2bfa0b66d99cd380c"
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

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import regex; print(regex.sub('.*', 'x', 'test'))"
    end
  end
end
