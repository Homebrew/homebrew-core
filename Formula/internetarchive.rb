class Internetarchive < Formula
  include Language::Python::Virtualenv

  desc "Python wrapper for the various Internet Archive APIs"
  homepage "https://github.com/jjjake/internetarchive"
  url "https://files.pythonhosted.org/packages/0d/69/62f671f7ec373801377715f0f1dba91f1d2d82be6994746feab118acd10c/internetarchive-1.4.0.tar.gz"
  sha256 "7f3d5f4dacc1834ec3745010f25dc727c0045a185225c826baa854cf7c79110b"

  bottle do
    cellar :any_skip_relocation
    sha256 "9283d4f9359f137de4dfb3003093d8336f47f669e245cd0cee3fcde0327a787c" => :sierra
    sha256 "87e65adbe1167171829bee10e960314477727a67d02f38fbaa398b48ba7d1f89" => :el_capitan
    sha256 "dc69ad664a021d8d8215a76e64c7064116ca2e4e0ba28f5430ea2c940d5ca811" => :yosemite
  end

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/b7/ad/760e2ebfced5f7ad4f12c6e0865f2cb646f183fb33ea6db58aa8e890db9c/jsonpatch-0.4.tar.gz"
    sha256 "43d725fb21d31740b4af177d482d9ae53fe23daccb13b2b7da2113fe80b3191e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/49/6f/183063f01aae1e025cf0130772b55848750a2f3a89bfa11b385b35d7329d/requests-2.10.0.tar.gz"
    sha256 "63f1815788157130cee16a933b2ee184038e975f0017306d723ac326b5525b54"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/b0/41/68972daad372fff3a2381e0416ff704faf524b2974e01d1c4fc997b4fb39/schema-0.4.0.tar.gz"
    sha256 "63f3ed23f3c383203bdac0c9a4c1fa823a507c3bfcd555954367a20a1c294973"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    # Required with Apple clang 7.0.0+/LLVM clang 3.6.0+ for gevent < 1.1.
    ENV.append "CFLAGS", "-std=gnu99" if ENV.compiler == :clang

    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/ia"
  end

  test do
    metadata = JSON.parse shell_output("#{bin}/ia metadata tigerbrew")
    assert_equal metadata["metadata"]["uploader"], "mistydemeo@gmail.com"
  end
end
