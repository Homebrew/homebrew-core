class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/59/ca/397e375554481d70356d29890d44398aec3b52a0484b32a7e25c487ee81e/pipenv-2025.0.3.tar.gz"
  sha256 "f0a67aa928824e61003d52acea72a94b180800019f03d38a311966f6330bc8d1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61d780b7a748b63bd05b46b5440d59814c1f2595ef2e46f4752acc1dd41ba209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61d780b7a748b63bd05b46b5440d59814c1f2595ef2e46f4752acc1dd41ba209"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "61d780b7a748b63bd05b46b5440d59814c1f2595ef2e46f4752acc1dd41ba209"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba1a02747fc9d34f12f94a4caefd785c4432e652f73fac7cacefd2a135fe1397"
    sha256 cellar: :any_skip_relocation, ventura:       "ba1a02747fc9d34f12f94a4caefd785c4432e652f73fac7cacefd2a135fe1397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "825e9f00270a3fd8a89de24fa7a0a25fefbd7744d582d0265ae6e3a437edfe0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "825e9f00270a3fd8a89de24fa7a0a25fefbd7744d582d0265ae6e3a437edfe0a"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/0d/dd/1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02d/distlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0a/10/c23352565a6544bdc5353e0b15fc1c563352101f30e24bf500207a54df9a/filelock-3.18.0.tar.gz"
    sha256 "adbc88eabb99d2fec8c9c1b229b171f18afa655400173ddc653d5d01501fb9f2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/56/2c/444f465fb2c65f40c3a104fd0c495184c4f2336d65baf398e3c75d72ea94/virtualenv-20.31.2.tar.gz"
    sha256 "e10c0a9d02835e592521be48b332b6caee6887f332c111aa79a09b9e79efc2af"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/pipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output(bin/"pipenv")
    system bin/"pipenv", "--python", which(python3)
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_path_exists testpath/"Pipfile"
    assert_path_exists testpath/"Pipfile.lock"
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
