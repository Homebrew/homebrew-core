class Gcovr < Formula
  desc "Reports from gcov test coverage program"
  homepage "https://gcovr.com/"
  url "https://github.com/gcovr/gcovr/archive/4.2.tar.gz"
  sha256 "589d5cb7164c285192ed0837d3cc17001ba25211e24933f0ba7cb9cf38b8a30e"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/gcovr/gcovr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9877f8a9da46667db0271977f2dcc1b2c95a21f0598b32e03cc8c9c50cd7c91" => :big_sur
    sha256 "9274fc9010345a944d75bf90c8418fd100b0195e910a3ab746fa36bddca352a4" => :arm64_big_sur
    sha256 "0e5e2e559d936a1bd54895b1f594f55d555a01d7a296abf8955ea6cb8293e01b" => :catalina
    sha256 "2398c9991b0a3817192dc11d84399ad1aed85b9e1730f8d10a2ce49bb86b5fc4" => :mojave
    sha256 "073e15e002cd9d40c63865632bf67e53913628c9bd940650fb781b724549d2fa" => :high_sierra
  end

  depends_on "python@3.9"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/d8/03/e491f423379ea14bb3a02a5238507f7d446de639b623187bccc111fbecdf/Jinja2-2.11.1.tar.gz"
    sha256 "93187ffbc7808079673ef52771baa950426fd664d3aad1d0fa3e95644360e250"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/39/2b/0a66d5436f237aff76b91e68b4d8c041d145ad0a2cdeefe2c42f76ba2857/lxml-4.5.0.tar.gz"
    sha256 "8620ce80f50d023d414183bf90cc2576c2837b88e00bea3f33ad2630133bbb60"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resources.each do |r|
      r.stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    (testpath/"example.c").write "int main() { return 0; }"
    system "cc", "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                 "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}/gcovr -r .")
  end
end
