class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://github.com/pipxproject/pipx"
  url "https://files.pythonhosted.org/packages/b5/42/bdf9b6cc0af79222f69776d931ef79235946095b16594bac1f6bd81f435f/pipx-0.13.0.1.tar.gz"
  sha256 "5134955d0d0595ca8040ecfa4215f2ddb84d34569c118ab2cde84b1d2b240b42"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fc35a71ccd0434ae3aed5d691bf93a3b5affd95419386c1e83da3acd93fb711" => :mojave
    sha256 "6fc35a71ccd0434ae3aed5d691bf93a3b5affd95419386c1e83da3acd93fb711" => :high_sierra
    sha256 "acc59a38f3133792b6929002195cfc066bf63746d1e05bde60ff684fabac4a8d" => :sierra
  end

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system "#{bin}/pipx", "install", "csvkit"
    assert_true FileTest.exist?("#{testpath}/.local/bin/csvjoin")
    system "#{bin}/pipx", "uninstall", "csvkit"
    assert_no_match Regexp.new("csvjoin"), shell_output("#{bin}/pipx list")
  end
end
