class PythonYq < Formula
  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://yq.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/56/5f/d60ffaba376257b60304a8ee9fafdc0be4852a4bcdeece48d931e6b36487/yq-2.6.0.tar.gz"
  sha256 "c64f763e8409ed55eb055793c26fc347b5a6666b303d49e9d2f8d7cea979df73"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca6ade4e6bdf9cc0897ea3c58bd5460fbf010b2bfed250aff40d9543ea04cac2" => :mojave
    sha256 "7365858d49340df37abf5fb5236ebef2516effacfdb748f89890121250786f38" => :high_sierra
    sha256 "7365858d49340df37abf5fb5236ebef2516effacfdb748f89890121250786f38" => :sierra
    sha256 "7365858d49340df37abf5fb5236ebef2516effacfdb748f89890121250786f38" => :el_capitan
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
