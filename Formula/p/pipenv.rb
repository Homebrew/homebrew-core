class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/b3/61/7f1d28d168eeaeed21eef4f117d482be061e277e890bc26fbfcdaa97c2f7/pipenv-2026.8.0.tar.gz"
  sha256 "ff0e3d61bfdb3d19ea1d912dfdfd62c9e5521fcc63e525de6a63818db8b4451f"
  license "MIT"
  head "https://github.com/pypa/pipenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cc09d51e6cb4eac16357f78321351d126d34c3cec9544188523ac06750221852"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name:     "pipenv[completion]",
                exclude_packages: "certifi"

  def python3
    "python3.14"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c9/02/bd72be9134d25ed783ecbbc38a539ffaefbf90c78418c7fb7229600dbac7/distlib-0.4.3.tar.gz"
    sha256 "f152097224a0ae24be5a0f6bae1b9359af82133bce63f98a95f86cae1aede9ed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/7d/64/a02e6765de08964ed371eca577870593245afc9dfac16d037de7c10d18e6/filelock-3.32.3.tar.gz"
    sha256 "0ffa185a3540854c95caa7fa76b76cb219d907415e2c5dc9af25fd970563487f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b8/d7/e7bfbc86e9f99ff7807e24de7703f032e9c9ba80bb355cf26e0e9bc5a75e/platformdirs-4.11.3.tar.gz"
    sha256 "66a73d38a849810252df809a3d8bcbda8e26f6c189920e7535ad608a48dbb5ab"
  end

  resource "python-discovery" do
    url "https://files.pythonhosted.org/packages/38/b7/ac44da2cf0e53ada0e419033c2d058219c95dc1403126f163304c9e814b1/python_discovery-1.5.2.tar.gz"
    sha256 "45fd4f20a4e3f9b7bf2e0817870bc8e3b320a19658da177af800768c82dbf354"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/2d/dc/a6eb1ddfa7f1e390fa599b078453c97edb3f6f846b34fb4eac3e8ea16401/virtualenv-21.7.4.tar.gz"
    sha256 "c9d960c95fa458171e58222a5ccab7465298e4b6559977865e627c4719f1e825"
  end

  def install
    venv = virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "pipenv", "--shell")

    # Build an `:all` bottle by replacing comments
    file = venv.site_packages.glob("argcomplete-*.dist-info/METADATA")
    inreplace file, "/opt/homebrew/bin/bash", "$HOMEBREW_PREFIX/bin/bash"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    system bin/"pipenv", "--python", which(python3)
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_path_exists testpath/"Pipfile"
    assert_path_exists testpath/"Pipfile.lock"
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
