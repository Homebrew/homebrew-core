class PythonYq < Formula
  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://yq.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/0c/23/aa30f88c916128aa60de9d4f53dd40c8f6c31cb7ebb808aab1b0501a701f/yq-2.7.2.tar.gz"
  sha256 "f7dafd1e53d1f806ffe11de6da814e231d866595e2faae0dfc38135b8ee79bbb"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3d388e9e69167f57f2b8f4e87322aeda5a940a1ce4227a43a671aeb19c06b04" => :mojave
    sha256 "ec55df02a3aaf3aca5d43e01047474bd83c5bea8bce6c469e81df8dcd7c73024" => :high_sierra
    sha256 "ec55df02a3aaf3aca5d43e01047474bd83c5bea8bce6c469e81df8dcd7c73024" => :sierra
  end

  depends_on "jq"
  depends_on "python"

  conflicts_with "yq", :because => "both install `yq` executables"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/57/17/a6acddc5f5993ea6eaf792b2e6c3be55e3e11f3b85206c818572585f61e1/xmltodict-0.11.0.tar.gz"
    sha256 "8f8d7d40aa28d83f4109a7e8aa86e67a4df202d9538be40c0cb1d70da527b0df"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["PYTHONPATH"] = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"

    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    env = {
      :PATH       => "#{Formula["jq"].opt_bin}:$PATH",
      :PYTHONPATH => ENV["PYTHONPATH"],
    }
    bin.env_script_all_files(libexec/"bin", env)
  end

  test do
    input = <<~EOS
      foo:
       bar: 1
       baz: {bat: 3}
    EOS
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
