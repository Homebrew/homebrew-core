class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  # homepage "https://www.breezy-vcs.org" temporary? 503
  homepage "https://github.com/breezy-team/breezy"
  url "https://files.pythonhosted.org/packages/42/05/abb86dd4d32d72a70ba4aeb7fa0eed5bfca8f23b911de66716f46fac224c/breezy-3.3.0.tar.gz"
  sha256 "f4d51f18e13555a2c04520bcf33cb97c6ee4551b286828c342f1d4df9dc5041c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec3a01b3f3b918cf378408857b9d0f7af17537376b08ee0cce4e3a8227eff97c"
    sha256 cellar: :any,                 arm64_monterey: "e0546eaad06c8b8637d96ef8229d8a1a1071eb65072df24b2e536d3ac83b405d"
    sha256 cellar: :any,                 arm64_big_sur:  "76e1a928b579aac251b6d5442a70535e1c08de14fa08e0c10440d69a922d6d05"
    sha256 cellar: :any,                 monterey:       "0f5169dbe93a51c251d622af47e229a195d10ce0049f164f72579cc5c62ad7ad"
    sha256 cellar: :any,                 big_sur:        "29eee450b62c2f96454041236c7c70a8a12c1c06a424bb882eabbf4c18e1481c"
    sha256 cellar: :any,                 catalina:       "008d045767508012da55077c79152cb6bf8d5e14bd636428bb0b4d46eb18901a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cfb8a8b54972dcd4ddec9e0547e84a71360c3572e0e8fc114ab7a7c5bf4dfcc"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  conflicts_with "bazaar", because: "both install `bzr` binaries"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/d1/20/4c2ea55d6547460a93dce9112599953be1c939155eae7a8e11a17c4d0b2c/dulwich-0.20.50.tar.gz"
    sha256 "50a941796b2c675be39be728d540c16b5b7ce77eb9e1b3f855650ece6832d2be"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/cd/e1/94ff8d7ce12ca1fa76b7299af27819829cc8feea125615e6e1f805e8f4e6/fastbencode-0.1.tar.gz"
    sha256 "c1a978e75a5048bba833d90d6e748a55950ca8b59f12e917c2a2c8e7ca7eb6f5"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/1b/ef/6543392d9dcca7694c9c9bff93562107c3a3c104165f98348de41a080cd3/merge3-0.0.11.tar.gz"
    sha256 "859ee1c31595c148f0961c55402779bc98c1c63dfdfca2f2cd7d443be6f0ab9c"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/28/48/ea6ff771aac65eb732f513f53eee22acc4020c0297e0597e3c517205ca73/patiencediff-0.2.7.tar.gz"
    sha256 "f4aff7ea161f692f3b6114c1492511eedc210738dc723dda6ff7d39124a7eb0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew <homebrew@example.com>"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end

    # Test git compatibility
    system brz, "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end
