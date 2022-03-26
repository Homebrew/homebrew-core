class Mkdocs < Formula
  include Language::Python::Virtualenv

  desc "Project documentation with Markdown"
  homepage "https://www.mkdocs.org/"
  url "https://files.pythonhosted.org/packages/65/64/126c28a69067d0f10ce3ec543595d3a1370ebc3015ff464aea5d8491d9d6/mkdocs-1.3.0.tar.gz"
  sha256 "b504405b04da38795fec9b2e5e28f6aa3a73bb0960cb6d5d27ead28952bd35ea"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bcd9a003375aebeaa630f819619eb558c22bf6ad2747b8d666047f6fec896bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4ca3b27f84dc4b971b7e1bc1fedc9700bcb98f9ed150a815cd15cf1edbb9625a"
    sha256 cellar: :any_skip_relocation, monterey:       "1c7c42d4743fd6412cd774cb8927d373e8d12af222f60d29f3fcb98635a5f93f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dff60ce3eb047811c3be499dce49c625382b5fa9e0cd49d68012c3b4694412b"
    sha256 cellar: :any_skip_relocation, catalina:       "b82807f2f342e2620a6564cf19bf6b63013fc82bfae1de1c5e73c500dcd2107a"
    sha256 cellar: :any_skip_relocation, mojave:         "16b50288230ca4e1c2e2b46f09c49414822835753458eb1dde125fa71be770b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77289d233c17b1c64951e6ccca3a78260d65401d7c63d0afe81152e4b2bdcd16"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/dd/cf/706c1ad49ab26abed0b77a2f867984c1341ed7387b8030a6aa914e2942a0/click-8.0.4.tar.gz"
    sha256 "8458d7b1287c5fb128c90e23381cf99dcde74beaf6c7ff6384ce84d6fe090adb"
  end

  resource "ghp-import" do
    url "https://files.pythonhosted.org/packages/13/b8/8dd1ea116774415b785c7c2e4bf91c2c50b5eae577bcc2d2a095c2ce20fd/ghp-import-2.0.2.tar.gz"
    sha256 "947b3771f11be850c852c64b561c600fdddf794bab363060854c1ee7ad05e071"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/3e/1d/964b27278cfa369fbe9041f604ab09c6e99556f8b7910781b4584b428c2f/importlib_metadata-4.11.3.tar.gz"
    sha256 "ea4c597ebf37142f827b8f39299579e31685c31d3a438b59f469406afd0f2539"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/89/e3/b36266381ae7a1310a653bb85f4f3658c462a69634fa9b2fef76252a50ed/Jinja2-3.1.1.tar.gz"
    sha256 "640bed4bb501cbd17194b3cace1dc2126f5b619cf068a726b98192a0fde74ae9"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/15/06/d60f21eda994b044cbd496892d4d4c5c708aa597fcaded7d421513cb219b/Markdown-3.3.6.tar.gz"
    sha256 "76df8ae32294ec39dcf89340382882dfa12975f87f45c3ed1ecdb1e8cefc7006"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "mergedeep" do
    url "https://files.pythonhosted.org/packages/3a/41/580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270/mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "pyyaml_env_tag" do
    url "https://files.pythonhosted.org/packages/fb/8e/da1c6c58f751b70f8ceb1eb25bc25d524e8f14fe16edcce3f4e3ba08629c/pyyaml_env_tag-0.1.tar.gz"
    sha256 "70092675bda14fdec33b31ba77e7543de9ddc88f2e5b99160396572d11525bdb"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/b3/d2/a04951838e0b0cea20aff5214109144e6869101818e7f90bf3b68ea2facf/watchdog-2.1.7.tar.gz"
    sha256 "3fd47815353be9c44eebc94cc28fe26b2b0c5bd889dafc4a5a7cbdf924143480"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/94/64/3115548d41cb001378099cb4fc6a6889c64ef43ac1b0e68c9e80b55884fa/zipp-3.7.0.tar.gz"
    sha256 "9f50f446828eb9d45b267433fd3e9da8d801f614129124863f9c51ebceafb87d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # build a very simple site that uses the "readthedocs" theme.
    (testpath/"mkdocs.yml").write <<~EOS
      site_name: MkLorum
      nav:
        - Home: index.md
      theme: readthedocs
    EOS
    mkdir testpath/"docs"
    (testpath/"docs/index.md").write <<~EOS
      # A heading

      And some deeply meaningful prose.
    EOS
    system "#{bin}/mkdocs", "build", "--clean"
  end
end
