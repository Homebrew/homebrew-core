class PythonHatchling < Formula
  desc "Modern, extensible Python build backend"
  homepage "https://github.com/pypa/hatch/tree/master/backend"
  url "https://files.pythonhosted.org/packages/fd/4a/8196e79c0d6e5eb10436dd2fcccc889a76af6ecf9bc35f87408159497d4d/hatchling-1.21.0.tar.gz"
  sha256 "5c086772357a50723b825fd5da5278ac7e3697cdf7797d07541a6c90b6ff754c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e79f1a78b3d9f6d7814edbe5140fcb53bb9076bdc7b15cd89d4131e8b16d4183"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36f35fa8ed3ea9075ff3d195f07a5a44d985bc4eb57e34d76c5ea1599d4a887e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44de9ab53cb29aef26197c2d61d6b845813e25869d1f0c3534bb409820ee2d8d"
    sha256 cellar: :any_skip_relocation, sonoma:         "652b620d635b8aa3c5280b112c60ec4d47f578a4e09215c48f9238a1d6b4e09a"
    sha256 cellar: :any_skip_relocation, ventura:        "06ac5463be01f286c47969dc69bbfe481291e8eb085e7dc206dac8410dd46b00"
    sha256 cellar: :any_skip_relocation, monterey:       "1750d678b19280556b2a5c0b24728c8a891f41bbfeafbbef8ade3869853f9a6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9110811d88d09b7534a15e6a0e937f43b3ed36a5823aa2f8c54ba7082409790"
  end

  depends_on "python-flit-core" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-packaging"
  depends_on "python-pathspec"
  depends_on "python-pluggy"
  depends_on "python-trove-classifiers"

  resource "editables" do
    url "https://files.pythonhosted.org/packages/37/4a/986d35164e2033ddfb44515168a281a7986e260d344cf369c3f52d4c3275/editables-0.5.tar.gz"
    sha256 "309627d9b5c4adc0e668d8c6fa7bac1ba7c8c5d415c2d27f60f081f8e80d1de2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/36/51/04defc761583568cae5fd533abda3d40164cbdcf22dee5b7126ffef68a40/pluggy-1.3.0.tar.gz"
    sha256 "cf61ae8f126ac6f7c451172cf30e3e43d3ca77615509771b3a984a0730651e12"
  end

  resource "trove-classifiers" do
    url "https://files.pythonhosted.org/packages/3d/14/fe9a127564317f1670d1dd2e2e74b9e09fc157563aa2ffbe7d113d004c7a/trove-classifiers-2023.11.29.tar.gz"
    sha256 "ff8f7fd82c7932113b46e7ef6742c70091cc63640c8c65db00d91f2e940b9514"
  end

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"

      resource("editables").stage do
        system python_exe, "-m", "pip", "install", *std_pip_args, "."
      end

      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      pyversion = Language::Python.major_minor_version(python_exe)
      bin.install bin/"hatchling" => "hatchling-#{pyversion}"

      next if python != pythons.max_by(&:version)

      # The newest one is used as the default
      bin.install_symlink "hatchling-#{pyversion}" => "hatchling"
    end
  end

  def caveats
    <<~EOS
      To run `hatchling`, you may need to `brew install #{pythons.last}`
    EOS
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import hatchling"
    end
  end
end
