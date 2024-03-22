class PythonTroveClassifiers < Formula
  desc "Canonical source for classifiers on PyPI"
  homepage "https://github.com/pypa/trove-classifiers"
  url "https://files.pythonhosted.org/packages/13/11/e13906315b498cb8f5ce5a7ff39fc35941e8291e914158157937fd1c095d/trove-classifiers-2024.3.3.tar.gz"
  sha256 "df7edff9c67ff86b733628998330b180e81d125b1e096536d83ac0fd79673fdc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3262cec2f58dc742124bf9b3995efc5b0e911404385449c48e3b4ea47b7a7b90"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9424ca80c4e12c2f556052b3c26d405614e4cdb6f196d09b6763f91ba2d6517b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5fe397804155f3f4c74dc341a09a9db3b01ba40ddb60a088982a95f3b2384cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "817ac9b2f73fc8e386ee78467923e2dce058ab8e9e4fc2a663e98442d7c38a01"
    sha256 cellar: :any_skip_relocation, ventura:        "ffb21cc20ee6c6d6fbf572506af28ae82ff79dba88223bed3fce603622c481c7"
    sha256 cellar: :any_skip_relocation, monterey:       "70b0c0c048af66ef1e4e122cf6da34a71b9bb2b7ce87877e16a86d0558320193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a2eddd72c1f6966e0102a9241c75c8042c5edcd91510c2d72a82c383e01f5b2"
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
      classifiers = shell_output("#{python_exe} -m trove_classifiers")
      assert_match "Environment :: MacOS X", classifiers
    end
  end
end
