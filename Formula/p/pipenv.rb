class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/61/54/90cc12be502209315c17f35fbe5f05f2497d8e6677d310b9c503ecf703d0/pipenv-2023.10.24.tar.gz"
  sha256 "a28a93ef66e5ce204cc33cab6df30cca80ceda1f0074f25cc251ee46da85ab39"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da76d29d5f6f08c67bd8a146dabd21c74d4673894a84de630f55d97ffdebe3af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41c648bebc945b74948675c42b8bb8eb6deb1cf1feccf1a3c7d1f024b210a553"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd1956c30d5468a72ac0c071fb4198ad1b2e16cf98e2d62f15b7274ea4b302fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "310c77a73a10d1aa39b9beb946fde25ac2785e32ff8f3a4c9a694cc538512309"
    sha256 cellar: :any_skip_relocation, ventura:        "0d75ee908e61366bbd5870cfe34c7a75c93e0a41ecc46b4be8188dda8a0b130b"
    sha256 cellar: :any_skip_relocation, monterey:       "9581b3947e35b6060c78117f704748d0f925ab1b58aa1dd4ea3119823480a2bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "819d788ffac243c076a38907c3f51c5e56d155487d15405cc483aa92bbee1989"
  end

  depends_on "python-certifi"
  depends_on "python@3.12"
  depends_on "virtualenv"

  def python3
    "python3.12"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.12")
    paths = %w[virtualenv].map { |p| Formula[p].opt_libexec/site_packages }
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

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
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system "#{bin}/pipenv", "--python", which(python3)
    system "#{bin}/pipenv", "install", "requests"
    system "#{bin}/pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
