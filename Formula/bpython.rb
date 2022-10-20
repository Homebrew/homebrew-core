class Bpython < Formula
  include Language::Python::Virtualenv

  desc "Fancy interface to the Python interpreter"
  homepage "https://bpython-interpreter.org"
  url "https://files.pythonhosted.org/packages/79/71/10573e8d9e1f947e330bdd77724750163dbd80245840f7e852c9fec493c4/bpython-0.23.tar.gz"
  sha256 "9f0078abc887c48af088691e2f64797d6ca994ac0f4bc03c38d06f657d7c052a"
  license "MIT"
  head "https://github.com/bpython/bpython.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2691994f9664ec103a5256ff652ca12cfd25dc37153d7716fba722b13a49fafb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbcf58ce27c89611685b6e064cb247dac4f93c28616fc6dc045d6e1fa10eee51"
    sha256 cellar: :any_skip_relocation, monterey:       "5f90deea3a869f68e39c3070293b4d1e600efb27f99759b9d9a163a49a0b9a99"
    sha256 cellar: :any_skip_relocation, big_sur:        "d435da4a52c90639dcb431f153a439693193d13f385ce3f65d88ce047fd2b6d8"
    sha256 cellar: :any_skip_relocation, catalina:       "4d80069b52216bb3a5799b73f4565c5b7ac3eea5585f26bde1cc117f5bd4f00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aea76d26423e782c7c67ed79877b0c2536554f3af97b0b5eeab248ff2def1ffa"
  end

  depends_on "pygments"
  depends_on "python@3.10"
  depends_on "six"

  resource "blessed" do
    url "https://files.pythonhosted.org/packages/e5/ad/97453480e7bdfce94f05a983cf7ad7f1d90239efee53d5af28e622f0367f/blessed-1.19.1.tar.gz"
    sha256 "9a0d099695bf621d4680dd6c73f6ad547f6a3442fbdbe80c4b1daa1edbc492fc"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "curtsies" do
    url "https://files.pythonhosted.org/packages/bc/40/7e1d986e890d0596f93c8509ccc95a3767daa279fcf2647a18eed7b1b865/curtsies-0.4.0.tar.gz"
    sha256 "cb29efce33fef395a29efa568f27f5913178469fb3aab114080d6ca6264142fe"
  end

  resource "cwcwidth" do
    url "https://files.pythonhosted.org/packages/c1/91/2101581c6a71cf13596311ebd981251bd84352ec275289b30042dd9de9e8/cwcwidth-0.1.7.tar.gz"
    sha256 "c0d647e12e3a4b15a881e1d84f796937516648489e011257237dc2179d6b1951"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/a0/d5/70772b3693f086a362f122516225a43fe4f1182e17158c81ba1ab271ab9b/greenlet-1.1.3.tar.gz"
    sha256 "bcb6c6dd1d6be6d38d6db283747d07fda089ff8c559a835236560a4410340455"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    python3 = Formula["python@3.10"].opt_bin/"python3.10"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install buildpath

    # Make the Homebrew site-packages available in the interpreter environment
    site_packages = Language::Python.site_packages(python3)
    ENV.prepend_path "PYTHONPATH", HOMEBREW_PREFIX/site_packages
    ENV.prepend_path "PYTHONPATH", libexec/site_packages
    combined_pythonpath = ENV["PYTHONPATH"] + "${PYTHONPATH:+:}$PYTHONPATH"
    %w[bpdb bpython].each do |cmd|
      (bin/cmd).write_env_script libexec/"bin/#{cmd}", PYTHONPATH: combined_pythonpath
    end
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4\n", shell_output("#{bin}/bpython test.py")
  end
end
