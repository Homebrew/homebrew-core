class Certifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/71/da/e94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96/certifi-2024.2.2.tar.gz"
  sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b9fe35ba7ec714a11ee069f140a5dc362204741d3e11f06319d13b90284e85c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d005dd12d5b75c44e43b8273ac6e6fb0f618ad7744dfa754c8746092e21cc51e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8428b22a89a1b10243e7d516f030afda91a8475aa58ded7b668f0c522a37d5db"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f36084a1caff922b19b4d7540e8e8be0419b31331fae048c0b7496b256c49c9"
    sha256 cellar: :any_skip_relocation, ventura:        "911c140acf37d3d5808dc4e059990a6955d8281fd8599733eed60b28054c371e"
    sha256 cellar: :any_skip_relocation, monterey:       "09f1aae317be7e27b2650b14dae4588070f8de1c4ecc03856ec238bf28e77ad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b8318f59c242ea8f1ee24380e4d5192f6f6939086a53641cceb9eb15642214c"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "ca-certificates"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

      # Use brewed ca-certificates PEM file instead of the bundled copy
      site_packages = Language::Python.site_packages("python#{python.version.major_minor}")
      rm prefix/site_packages/"certifi/cacert.pem"
      (prefix/site_packages/"certifi").install_symlink Formula["ca-certificates"].pkgetc/"cert.pem" => "cacert.pem"
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      output = shell_output("#{python_exe} -m certifi").chomp
      assert_equal Formula["ca-certificates"].pkgetc/"cert.pem", Pathname(output).realpath
    end
  end
end
