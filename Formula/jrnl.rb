class Jrnl < Formula
  include Language::Python::Virtualenv

  desc "Command-line note taker"
  homepage "https://jrnl.sh/"
  url "https://files.pythonhosted.org/packages/82/95/0853c227abcbead539b624cd0c98f959f141e261dbe7c9be350aecdfdbfe/jrnl-2.8.3.tar.gz"
  sha256 "089c7f2e61c31809b96efc4e3d3ae9fcc6354257e27406754f3a4a1a37029574"
  license "GPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fcdcdfc09aab5b927f4ed89ce7d42559c84831707c97ed572697c97dfea5f985"
    sha256 cellar: :any,                 arm64_big_sur:  "d9c5a290f6761fad179a7d51621d4dc47f9d9c979f9dcfb358b943f8c70c5c92"
    sha256 cellar: :any,                 monterey:       "4eedaa815db33fac4fd98c68f690a2aab0010c05829ca213d1a560f372260d84"
    sha256 cellar: :any,                 big_sur:        "812efe64f0ce448710e634e8c0f3d7f2f03685319fba067db571724c3f0c96c6"
    sha256 cellar: :any,                 catalina:       "fb2add6dbf23957ea55379a1610148e677af792673f6530239b054a3d1409cd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc76e19e8a3a2151a4b25591bc255daefd33343c8d7104792360dec17b5f4513"
  end

  depends_on "rust" => :build
  depends_on "python@3.9"

  uses_from_macos "expect" => :test

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "ansiwrap" do
    url "https://files.pythonhosted.org/packages/7c/45/2616341cfcace37d4619d5106a85fcc24f2170d1a161bc5f7fdb81772fbc/ansiwrap-0.8.4.zip"
    sha256 "ca0c740734cde59bf919f8ff2c386f74f9a369818cdc60efe94893d01ea8d9b7"
  end

  resource "asteval" do
    url "https://files.pythonhosted.org/packages/f0/81/c1385350267c5c02be74acba7167fd6608083324a51421c6b8a57240eb35/asteval-0.9.25.tar.gz"
    sha256 "bea22b7d8fa16bcba95ebc72052ae5d8ca97114c9959bb47f8b8eebf30e4342f"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f9/4b/1cf8e281f7ae4046a59e5e39dd7471d46db9f61bb564fddbff9084c4334f/cryptography-36.0.1.tar.gz"
    sha256 "53e5c1dc3d7a953de055d77bef2ff607ceef7a2aac0353b5d630ab67f7423638"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/50/05/fef7fbb7e781e0632ebba4e6e37bcc88b9615e76338850dc31435091ddc0/importlib_metadata-4.10.0.tar.gz"
    sha256 "92a8b58ce734b2a4494878e0ecf7d79ccd7a128b5fc6014c401e0b61f006f0f6"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/28/46/d9b750ae5fb5b4fd77d169f16d87987db7d358a5eefc72be7967d4493d17/keyring-23.4.0.tar.gz"
    sha256 "88f206024295e3c6fb16bb0a60fb4bb7ec1185629dc5a729f12aa7c236d01387"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/e3/8e/1cde9d002f48a940b9d9d38820aaf444b229450c0854bdf15305ce4a3d1a/pytz-2021.3.tar.gz"
    sha256 "acad2d8b20a1af07d4e4c9d2e9285c5ed9104354062f275f3fcd88dcef4f1326"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/6f/2e/2251b5ae2f003d865beef79c8fcd517e907ed6a69f58c32403cec3eba9b2/pyxdg-0.27.tar.gz"
    sha256 "80bd93aae5ed82435f20462ea0208fb198d8eec262e831ee06ce9ddb6b91c5a5"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "textwrap3" do
    url "https://files.pythonhosted.org/packages/4d/02/cef645d4558411b51700e3f56cefd88f05f05ec1b8fa39a3142963f5fcd2/textwrap3-0.9.2.zip"
    sha256 "5008eeebdb236f6303dcd68f18b856d355f6197511d952ba74bc75e40e0c3414"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/ce/73/99e4cc30db6b21cba6c3b3b80cffc472cc5a0feaf79c290f01f1ac460710/tzlocal-2.1.tar.gz"
    sha256 "643c97c5294aedc737780a49d9df30889321cbe1204eac2c2ec6134035a92e44"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/94/64/3115548d41cb001378099cb4fc6a6889c64ef43ac1b0e68c9e80b55884fa/zipp-3.7.0.tar.gz"
    sha256 "9f50f446828eb9d45b267433fd3e9da8d801f614129124863f9c51ebceafb87d"
  end

  resource "asn1crypto" do
    on_linux do
      url "https://files.pythonhosted.org/packages/9f/3d/8beae739ed8c1c8f00ceac0ab6b0e97299b42da869e24cf82851b27a9123/asn1crypto-1.3.0.tar.gz"
      sha256 "5a215cb8dc12f892244e3a113fe05397ee23c5c4ca7a69cd6e69811755efc42d"
    end
  end

  resource "jeepney" do
    on_linux do
      url "https://files.pythonhosted.org/packages/74/24/9b720cc6b2a73c908896a0ed64cb49780dcfbf4964e23a725aa6323f4452/jeepney-0.4.3.tar.gz"
      sha256 "3479b861cc2b6407de5188695fa1a8d57e5072d7059322469b62628869b8e36e"
    end
  end

  resource "secretstorage" do
    on_linux do
      url "https://files.pythonhosted.org/packages/fd/9f/36197c75d9a09b1ab63f56cb985af6cd858ca3fc41fd9cd890ce69bae5b9/SecretStorage-3.1.2.tar.gz"
      sha256 "15da8a989b65498e29be338b3b279965f1b8f09b9668bd8010da183024c8bff6"
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
        "You can always change this later" { send -- "n\r" }
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
        -exact "Do you want to store the password in your keychain? \[Y/n\] " { send -- "n\r" }
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
