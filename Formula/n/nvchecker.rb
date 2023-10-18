class Nvchecker < Formula
  include Language::Python::Virtualenv

  desc "New version checker for software releases"
  homepage "https://github.com/lilydjwg/nvchecker"
  url "https://files.pythonhosted.org/packages/22/25/e42c9be788883c94ed3a2bbaf37c2351cfe0d82cdb96676a629ed3adedec/nvchecker-2.12.tar.gz"
  sha256 "4200ddf733448c52309f110c6fa916727a7400f444855afa8ffe7ff1e5b0b6c8"
  license "MIT"
  revision 2

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1d6abf66947c36ef620be172cd8531d950e785574f187853b5ba5201c9981ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b215c8739de7b77d460e5b9621ca084d0b603dcee89ab33483d7fb422ab1c7f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb239f66c865aaa1a0bf73ff04eff61fde5322f2510db6e3dfb0a1c3d694b447"
    sha256 cellar: :any_skip_relocation, sonoma:         "92f4c4ac52e991d8fef6e9caf2b2d57d3eaf518bbda345ff3b50280b5db4a7be"
    sha256 cellar: :any_skip_relocation, ventura:        "7675910c53e81945064dae7594d50f37a2fbeac2c9aa4b2704a1f9e6ca3c16f1"
    sha256 cellar: :any_skip_relocation, monterey:       "ffa9fe0ebd5bc5126bc63f90624665857f0f6bef0801915ed156c6d9f8c8edec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06be258da8babd9595f84be864cc23633a0d2405578822604aa7e446a90a78b0"
  end

  depends_on "jq" => :test
  depends_on "python-packaging"
  depends_on "python-pycurl"
  depends_on "python@3.12"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  resource "structlog" do
    url "https://files.pythonhosted.org/packages/99/4c/67e8cc235bbeb0a87053739c4c9d0619e3f284730ebdb2b34349488d9e8a/structlog-23.2.0.tar.gz"
    sha256 "334666b94707f89dbc4c81a22a8ccd34449f0201d5b1ee097a030b577fa8c858"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/48/64/679260ca0c3742e2236c693dc6c34fb8b153c14c21d2aa2077c5a01924d6/tornado-6.3.3.tar.gz"
    sha256 "e7d8db41c0181c80d76c982aacc442c0783a2c54d6400fe028954201a2e032fe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    file = testpath/"example.toml"
    file.write <<~EOS
      [nvchecker]
      source = "pypi"
      pypi = "nvchecker"
    EOS

    out = shell_output("#{bin}/nvchecker -c #{file} --logger=json | jq '.[\"version\"]' ").strip
    assert_equal "\"#{version}\"", out
  end
end
