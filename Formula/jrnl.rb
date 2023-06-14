class Jrnl < Formula
  include Language::Python::Virtualenv

  desc "Command-line note taker"
  homepage "http://jrnl.sh/en/stable/"
  url "https://files.pythonhosted.org/packages/12/93/f87d3be36966102ba3839740af45dc9d9f94d1b1116c3dc872a082d4654c/jrnl-4.0.tar.gz"
  sha256 "ea690cb141cbd39f491eca6c56605491facbaa9397cfa8f9fcae5b926efd522d"
  license "GPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "304200a0e8bd8063ef41e63507432fd3d64f240718187313c603ecfe02779304"
    sha256 cellar: :any,                 arm64_monterey: "5d78a3b38d11ffd3750e1a77497d1fafecc173e3cea502ccec772d3587edc656"
    sha256 cellar: :any,                 arm64_big_sur:  "aab65932ba23d37f057c614b6da7dbe821254e8cf29e01a40f297c81d1cd0ba0"
    sha256 cellar: :any,                 ventura:        "1dbb9f2a2fba16fd946d2903a2345b9063259c5136c9daca7da03bdb094bc036"
    sha256 cellar: :any,                 monterey:       "6a014337f145b940e1f12f78f8f445a5bad441704e5f197751aa6fe0e1ef4bce"
    sha256 cellar: :any,                 big_sur:        "1a063ee739d15bd873726d0ea2ba3b448614a5de8ecb74165d0922e82a834601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa58b83ba3a450fe3563aae1f630108aa86531be7223be9939bbff6b17018d11"
  end

  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "expect" => :test

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "ansiwrap" do
    url "https://files.pythonhosted.org/packages/7c/45/2616341cfcace37d4619d5106a85fcc24f2170d1a161bc5f7fdb81772fbc/ansiwrap-0.8.4.zip"
    sha256 "ca0c740734cde59bf919f8ff2c386f74f9a369818cdc60efe94893d01ea8d9b7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/0b/1f/9de392c2b939384e08812ef93adf37684ec170b5b6e7ea302d9f163c2ea0/importlib_metadata-6.6.0.tar.gz"
    sha256 "92501cdf9cc66ebd3e612f1b4f0c0765dfa42f0fa38ffb319b6bd84dd675d705"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/55/fe/282f4c205add8e8bb3a1635cbbac59d6def2e0891b145aa553a0e40dd2d0/keyring-23.13.1.tar.gz"
    sha256 "ba2e15a9b35e21908d0aaf4e0a47acc52d6ae33444df0da2b49d41a46ef6d678"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/e4/c0/59bd6d0571986f72899288a95d9d6178d0eebd70b6650f1bb3f0da90f8f7/markdown-it-py-2.2.0.tar.gz"
    sha256 "7c9a5e412688bc771c67432cbfebcdd686c93ce6484913dccf06cb5a0bea35a1"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2e/d0/bea165535891bd1dcb5152263603e902c0ec1f4c9a2e152cc4adff6b3a38/more-itertools-9.1.0.tar.gz"
    sha256 "cabaa341ad0389ea83c17a94566a53ae4c9d07349861ecb14dc6d0345cf9ac5d"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/02/97/0046b5e3c6a5057b5817e5e6c51a776d410b953e6a9c67ae249dafdd2999/rich-13.4.1.tar.gz"
    sha256 "76f6b65ea7e5c5d924ba80e322231d7cb5b5981aa60bfc1e694f1bc097fe6fe1"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/46/a9/6ed24832095b692a8cecc323230ce2ec3480015fbfa4b79941bd41b23a3c/ruamel.yaml-0.17.21.tar.gz"
    sha256 "8b7ce697a2f212752a35c1ac414471dc16c424c9573be4926b56ff3f5d23b7af"
  end

  resource "textwrap3" do
    url "https://files.pythonhosted.org/packages/4d/02/cef645d4558411b51700e3f56cefd88f05f05ec1b8fa39a3142963f5fcd2/textwrap3-0.9.2.zip"
    sha256 "5008eeebdb236f6303dcd68f18b856d355f6197511d952ba74bc75e40e0c3414"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ee/f5/3e644f08771b242f7460438cdc0aaad4d1484c1f060f1e52f4738d342983/tzlocal-5.0.1.tar.gz"
    sha256 "46eb99ad4bdb71f3f72b7d24f4267753e240944ecfc16f25d2719ba89827a803"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  resource "jeepney" do
    on_linux do
      url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end
  end

  resource "SecretStorage" do
    on_linux do
      url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"tests.sh").write <<~EOS
      #!/usr/bin/env expect

      set timeout 3
      match_max 100000

      # Write the journal
      spawn "#{bin}/jrnl" "This is the fanciest test in the world."

      expect {
        "/.local/share/jrnl/journal.txt" { send -- "#{testpath}/test.txt\r" }
        timeout { exit 1 }
      }

      expect {
        "Do you want to encrypt your journal?" { send -- "n\r" }
        timeout { exit 1 }
      }

      expect {
        "Do you want jrnl to use colors when displaying entries?" { send -- "n\r" }
        timeout { exit 1 }
      }

      expect {
        eof { exit }
        timeout { exit 1 }
      }

      # Read the journal
      spawn "#{bin}/jrnl" -1

      expect {
        "This is the fanciest test in the world." { exit }
        timeout { exit 1 }
        eof { exit 1 }
      }

      # Encrypt the journal
      spawn "#{bin}/jrnl" --encrypt

      expect {
        -exact "Enter password for new journal: " { send -- "homebrew\r" }
        timeout { exit 1 }
      }

      expect {
        -exact "Enter password again: " { send -- "homebrew\r" }
        timeout { exit 1 }
      }

      expect {
        -exact "Do you want to store the password in your keychain? [Y/n] " { send -- "n\r" }
        timeout { exit 1 }
      }

      expect {
        -re "Journal encrypted to .*/test.txt." { exit }
        timeout { exit 1 }
        eof { exit 1 }
      }
    EOS

    system "expect", "./tests.sh"
    assert_predicate testpath/".config/jrnl/jrnl.yaml", :exist?
    assert_predicate testpath/"test.txt", :exist?
  end
end
