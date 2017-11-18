class EyeD3 < Formula
  desc "Work with ID3 metadata in .mp3 files"
  homepage "http://eyed3.nicfit.net/"
  url "http://eyed3.nicfit.net/releases/eyeD3-0.8.4.tar.gz"
  sha256 "9a8f334c640813647062aaa46c52d65641bec6f7d7e73e51441c95d3d93c3f43"

  bottle do
    cellar :any_skip_relocation
    sha256 "23bdb9dd77c6a9b32c0cf3519f40f9311a42a98caf12f1250ba07e523cb62df0" => :high_sierra
    sha256 "23bdb9dd77c6a9b32c0cf3519f40f9311a42a98caf12f1250ba07e523cb62df0" => :sierra
    sha256 "85f776951f8ac0691a2f3c446860075950845a2fde2bfc7ccc8100df11446f63" => :el_capitan
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libmagic"

  # Looking for documentation? Please submit a PR to build some!
  # See https://github.com/Homebrew/homebrew/issues/32770 for previous attempt.

  resource "pathlib" do
    url "https://files.pythonhosted.org/packages/ac/aa/9b065a76b9af472437a0059f77e8f962fe350438b927cb80184c32f075eb/pathlib-1.0.1.tar.gz"
    sha256 "6940718dfc3eff4258203ad5021090933e5c04707d5ca8cc9e73c94a7894ea9f"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/65/0b/c6b31f686420420b5a16b24a722fe980724b28d76f65601c9bc324f08d02/python-magic-0.4.13.tar.gz"
    sha256 "604eace6f665809bebbb07070508dfa8cabb2d7cb05be9a56706c60f864f1289"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Install in our prefix, not the first-in-the-path python site-packages dir.
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"

    system "python", "setup.py", "install", "--prefix=#{libexec}"
    share.install "docs/plugins", "docs/cli.rst"

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    touch "temp.mp3"
    system "#{bin}/eyeD3", "-a", "HomebrewYo", "-n", "37", "temp.mp3"
  end
end
