class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org"
  url "https://files.pythonhosted.org/packages/40/1d/b653f9646b738a47d8e61bcd5a2509fdd874484c5ea141f900de973bb2b4/breezy-3.0.1.tar.gz"
  sha256 "a118276a1eb8948f30c3f043f7e7a1c20d4e8bb1e0044005d524e0a53f3ca3cb"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "00918e00399cb3a0d6b44853188813aa6f83d9bf7cfd77fb00497676e8b51345" => :mojave
    sha256 "284712ef6477ee70cc9227dd14c30dc00dd486a1c8e3e1c8eaf5c246715edaf9" => :high_sierra
    sha256 "fb5016b13d3d3499d3799cac27b8245eb60e06a3fb292f8e67269c52c07d5a35" => :sierra
  end

  depends_on "gettext" => :build
  depends_on "openssl@1.1"
  depends_on "python"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/64/61/079eb60459c44929e684fa7d9e2fdca403f67d64dd9dbac27296be2e0fab/configobj-5.0.6.tar.gz"
    sha256 "a2f5650770e1c87fb335af19a9b7eb73fc05ccf22144eb68db7d00cd2bcb0902"
  end

  resource "Cython" do
    url "https://files.pythonhosted.org/packages/5b/5b/6cba7123a089c4174f944dd05ea7984c8d908aba8746a99f2340dde8662f/Cython-0.29.12.tar.gz"
    sha256 "20da832a5e9a8e93d1e1eb64650258956723940968eb585506531719b55b804f"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/2e/02/42ce6e45a206ccb044d8a3296646497e96b5263624e5862d21da947b9d59/dulwich-0.19.11.tar.gz"
    sha256 "afbe070f6899357e33f63f3f3696e601731fef66c64a489dea1bc9f539f4a725"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/54/68/dde7919279d4ecdd1607a7eb425a2874ccd49a73a5a71f8aa4f0102d3eb8/paramiko-2.6.0.tar.gz"
    sha256 "f4b2edfa0d226b70bd4ca31ea7e389325990283da23465d572ed1f70a7583041"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4c/13/2386233f7ee40aa8444b47f7463338f3cbdf00c316627558784e3f542f07/urllib3-1.25.3.tar.gz"
    sha256 "dbe59173209418ae49d485b87d1681aefa36252ee85884c31346debd19463232"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew"
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
