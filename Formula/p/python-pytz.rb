class PythonPytz < Formula
  desc "Python library for cross platform timezone"
  homepage "https://pythonhosted.org/pytz/"
  url "https://files.pythonhosted.org/packages/69/4f/7bf883f12ad496ecc9514cd9e267b29a68b3e9629661a2bbc24f80eff168/pytz-2023.3.post1.tar.gz"
  sha256 "7b4fddbeb94a1eba4b557da24f19fdf9db575192544270a9101d8509f9f43d7b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b99fb8dab5b98069bb640175f56235e16a71105796219c5c7960c12de5a44c20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39d248d9999276c3a2ad0ef97b7a4a671bcf5dda26496fbcc34c9457dae01f54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4b0b2ce31bfad29741d681a76b2041842729c4dfb1302eccf786f3515346697"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d98be4136ca5f494c89c6a2b0dfd2024956250ef9491ffa1fa14ccd8f60a7f3c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f44c656114f3cb60ba6eb54f0e5fff08c99c50f3009302a28fa7ddac246e3ba7"
    sha256 cellar: :any_skip_relocation, ventura:        "4e3b0a220b070ef3945f950b02882fb4745d111fd61630698dd299464c960dac"
    sha256 cellar: :any_skip_relocation, monterey:       "607ac36d8d2611cd0c459c1143ac23c3e51f9c31205f46657aa05df0c07ab84e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0aac2ed6e7d13bc29144943aeaab41401963e2d78cdbcd16f08ac37c06f4dd1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82f97ef75ba53f915206d40121cfc4b474f916122f2cb154e780880ac185b24a"
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
      system python_exe, "-c", "import pytz; print(pytz.timezone('UTC'))"
    end
  end
end
