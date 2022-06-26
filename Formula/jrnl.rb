class Jrnl < Formula
  include Language::Python::Virtualenv

  desc "Command-line note taker"
  homepage "http://jrnl.sh/en/stable/"
  url "https://files.pythonhosted.org/packages/11/5c/dfbccbe2d5042b89240c9e3af48aa8c79c462981330e397b656490a9b997/jrnl-2.8.4.tar.gz"
  sha256 "3838f0b55708b9b9b2c2706fb671bd83f444d321635e3ce19cda2304992d4f60"
  license "GPL-3.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7c7063931813b3a94a85df1189505e594fad84f033fb768bc8bac8d740b76d2e"
    sha256 cellar: :any,                 arm64_big_sur:  "bcfeab32405f751366ea962c7cd6c46026ffc31b51b9a5c9128b5cb3b0684baa"
    sha256 cellar: :any,                 monterey:       "9f9b041f7d96c020ae5d98c20be4be318979a8c756df84db62ccde7c02ce4676"
    sha256 cellar: :any,                 big_sur:        "c570c69f9d96c426f13e38b4e8f7f2ee0e053335caab594aaec5301328c44f25"
    sha256 cellar: :any,                 catalina:       "946299a70b6b0a134f8540a0e41ddb8d7b629cc10260c331857d6643c38dab6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2f8faecf4e7a4c5977bacee858b6348a2e5183c1b8d3a51df1665d27425f518"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  uses_from_macos "expect" => :test

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "ansiwrap" do
    url "https://files.pythonhosted.org/packages/7c/45/2616341cfcace37d4619d5106a85fcc24f2170d1a161bc5f7fdb81772fbc/ansiwrap-0.8.4.zip"
    sha256 "ca0c740734cde59bf919f8ff2c386f74f9a369818cdc60efe94893d01ea8d9b7"
  end

  resource "asteval" do
    url "https://files.pythonhosted.org/packages/52/7f/f3c62addf40b81a2deb55f484fcaf8655984b595055a652f37fee9d20e2f/asteval-0.9.26.tar.gz"
    sha256 "36125613ec21ed3e33e370ca8960a1f1e8a2324d78a8016bfa5ad76f1e16ef05"
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
    url "https://files.pythonhosted.org/packages/51/05/bb2b681f6a77276fc423d04187c39dafdb65b799c8d87b62ca82659f9ead/cryptography-37.0.2.tar.gz"
    sha256 "f224ad253cc9cea7568f49077007d2263efa57396a2f2f78114066fd54b5c68e"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/35/a8/f2bd0d488c2bf932b4dda0fb91cbb687c0b1132b33130d1cfad4e2b4b963/importlib_metadata-4.11.4.tar.gz"
    sha256 "5d26852efe48c0a32b0509ffbc583fda1a2266545a78d104a6f4aff3db17d700"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/22/2b/e840597838cc63f96926bd7daca67936031635cfe6c81ee12dc652bd2dce/keyring-23.5.0.tar.gz"
    sha256 "9012508e141a80bd1c0b6778d5c610dd9f8c464d75ac6774248500503f972fb9"
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
    url "https://files.pythonhosted.org/packages/2f/5f/a0f653311adff905bbcaa6d3dfaf97edcf4d26138393c6ccd37a484851fb/pytz-2022.1.tar.gz"
    sha256 "1e760e2fe6a8163bc0b3d9a19c4f84342afa0a2affebfaa84b01b978a02ecaa7"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/6f/2e/2251b5ae2f003d865beef79c8fcd517e907ed6a69f58c32403cec3eba9b2/pyxdg-0.27.tar.gz"
    sha256 "80bd93aae5ed82435f20462ea0208fb198d8eec262e831ee06ce9ddb6b91c5a5"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
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
    url "https://files.pythonhosted.org/packages/cc/3c/3e8c69cd493297003da83f26ccf1faea5dd7da7892a0a7c965ac3bcba7bf/zipp-3.8.0.tar.gz"
    sha256 "56bf8aadb83c24db6c4b577e13de374ccfb67da2078beba1d037c17980bf43ad"
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
