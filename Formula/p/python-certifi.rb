class PythonCertifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/d4/91/c89518dd4fe1f3a4e3f6ab7ff23cb00ef2e8c9adf99dacc618ad5e068e28/certifi-2023.11.17.tar.gz"
  sha256 "9b469f3a900bf28dc19b8cfbf8019bf47f7fdd1a65a1d4ffb98fc14166beb4d1"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "907b42dc137066943c4c3b0a44adc7a8cbc73be3464324b153cfe4e08655987c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "747a885c9fd8935a23942e7e148f76029365fb4223f1d4ed138859cb3f1eba0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c149eb678ea932c0307bdb3fc9feb0e7ee94515dd92e960dca2ccb632d4b4e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd1635c8dc3a28333e9d107c8605d2381203409d8d016f96e5020065c659a438"
    sha256 cellar: :any_skip_relocation, ventura:        "6c0ef13bda23ce00c75e91f153ebb27005fa687151e0cd2c7cf4798329892b2b"
    sha256 cellar: :any_skip_relocation, monterey:       "4cd160dd762709bcc0d7efe05e1b18fbb6367c218ef373754d64bb6e5dc0f56e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27f860b70fe796a17a9d6bbbe170759bd3118e56636d56e930f984e1c44d2dbf"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "ca-certificates"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."

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
