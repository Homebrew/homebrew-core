class Poetry < Formula
  include Language::Python::Virtualenv

  desc "Python package management tool"
  homepage "https://python-poetry.org/"
  url "https://files.pythonhosted.org/packages/57/93/30798f4df5633eaae1de4d851428fa72d281f949366c116eb21ed41530c5/poetry-1.1.11.tar.gz"
  sha256 "7d7d22f55fbebb830cc85b1c69cd7a91fd85f49e5396e7a14b953645a470f69e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ae280fc23dc2e22b2834dedc7bc6a1e82cda13c5768dccb2978ee2f582a469e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d5b4426cff6cce5bce2d71bd91f4e6f24dd3b7437dfad54839dc113fe360e7a"
    sha256 cellar: :any_skip_relocation, monterey:       "bc38c9837be72695c0d850dc8e7415c4c510c540f7562f19fc68a1efedad9270"
    sha256 cellar: :any_skip_relocation, big_sur:        "109beda4eebb47a07739ee82585b83b33d698fcfc182000dd1c3de48a73e6e0e"
    sha256 cellar: :any_skip_relocation, catalina:       "df7c08b1afa8c61d53a6178f060c357d986557b0678a795ed6cae940778e35cd"
    sha256 cellar: :any_skip_relocation, mojave:         "e774a5fa46defd516cee58eb9bcace102b3b8ec9d101dbd796df7b0a55d497fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e33f71e0e2507519a6f11ecf51fc9657f932d01676ddf98186c55931441d4116"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "backports.entry-points-selectable" do
    url "https://files.pythonhosted.org/packages/e4/7e/249120b1ba54c70cf988a8eb8069af1a31fd29d42e3e05b9236a34533533/backports.entry_points_selectable-1.1.0.tar.gz"
    sha256 "988468260ec1c196dab6ae1149260e2f5472c9110334e5d51adcb77867361f6a"
  end

  resource "CacheControl" do
    url "https://files.pythonhosted.org/packages/44/b9/9a1d4349824ae14de4052e84802a0c372fff1fd2bd6668f7e9efe91ac11d/CacheControl-0.12.6.tar.gz"
    sha256 "be9aa45477a134aee56c8fac518627e1154df063e85f67d4f83ce0ccc23688e8"
  end

  resource "cachy" do
    url "https://files.pythonhosted.org/packages/a0/0c/45b249b0efce50a430b8810ec34c5f338d853c31c24b0b297597fd28edda/cachy-0.3.0.tar.gz"
    sha256 "186581f4ceb42a0bbe040c407da73c14092379b1e4c0e327fdb72ae4a9b269b1"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/eb/7f/a6c278746ddbd7094b019b08d1b2187101b1f596f35f81dc27f57d8fcf7c/charset-normalizer-2.0.6.tar.gz"
    sha256 "5ec46d183433dcbd0ab716f2d7f29d8dee50505b3fdb40c6b985c7c4f5a3591f"
  end

  resource "cleo" do
    url "https://files.pythonhosted.org/packages/a5/36/943c12bc9b56f5fc83661558c576a3d95df0d0f9c153f87ee4c19647025b/cleo-0.8.1.tar.gz"
    sha256 "3d0e22d30117851b45970b6c14aca4ab0b18b1b53c8af57bed13208147e4069f"
  end

  resource "clikit" do
    url "https://files.pythonhosted.org/packages/0b/07/27d700f8447c0ca81454a4acdb7eb200229a6d06fe0b1439acc3da49a53f/clikit-0.6.2.tar.gz"
    sha256 "442ee5db9a14120635c5990bcdbfe7c03ada5898291f0c802f77be71569ded59"
  end

  resource "crashtest" do
    url "https://files.pythonhosted.org/packages/08/3c/5ec13020a4693fab34e1f438fe6e96aed6551740e1f4a5cc66e8b84491ea/crashtest-0.3.1.tar.gz"
    sha256 "42ca7b6ce88b6c7433e2ce47ea884e91ec93104a4b754998be498a8e6c3d37dd"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/56/ed/9c876a62efda9901863e2cc8825a13a7fcbda75b4b498103a4286ab1653b/distlib-0.3.3.zip"
    sha256 "d982d0751ff6eaaab5e2ec8e691d949ee80eddf01a62eaa96ddb11531fe16b05"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/fd/6e/665a6cb363bee26e40954ee812e4e733fd7cafd84c06e0c7c2357641abd6/filelock-3.3.0.tar.gz"
    sha256 "8c7eab13dc442dc249e95158bcc12dec724465919bdc9831fdbf0660f03d1785"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/f0/70/ca3dd67cdd368b957e73a8156f7e1a10339f9813e314cb8b4549526070da/importlib_metadata-4.8.1.tar.gz"
    sha256 "f284b3e11256ad1e5d03ab86bb2ccd6f5339688ff17a4d797a0fe7df326f23b1"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/19/c7/e1a9c556745518c9c3d46613c10a968757b16e29341ec8e0815fd07e0f93/keyring-21.8.0.tar.gz"
    sha256 "1746d3ac913d449a090caf11e9e4af00e26c3f7f7e81027872192b2398b98675"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/59/04/87fc6708659c2ed3b0b6d4954f270b6e931def707b227c4554f99bd5401e/msgpack-1.0.2.tar.gz"
    sha256 "fae04496f5bc150eefad4e9571d1a76c55d021325dcd484ce45065ebbdd00984"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pastel" do
    url "https://files.pythonhosted.org/packages/76/f1/4594f5e0fcddb6953e5b8fe00da8c317b8b41b547e2b3ae2da7512943c62/pastel-0.2.1.tar.gz"
    sha256 "e6581ac04e973cac858828c6202c1e1e81fee1dc7de7683f3e1ffe0bfd8a573d"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/23/3f/f2251c754073cda0f00043a707cba7db103654722a9afed965240a0b2b43/pkginfo-1.7.1.tar.gz"
    sha256 "e7432f81d08adec7297633191bbf0bd47faf13cd8724c3a13250e51d542635bd"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/4b/96/d70b9462671fbeaacba4639ff866fb4e9e558580853fc5d6e698d0371ad4/platformdirs-2.4.0.tar.gz"
    sha256 "367a5e80b3d04d2428ffa76d33f124cf11e8fff2acdaa9b43d545f5c7d661ef2"
  end

  resource "poetry-core" do
    url "https://files.pythonhosted.org/packages/40/d0/adc9ab25f68d9382f32c355627423a32135efaa5aaeebd6dec6d19e6b0af/poetry-core-1.0.7.tar.gz"
    sha256 "98c11c755a16ef6c5673c22ca94a3802a7df4746a0853a70b6fae8b9f5cac206"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pylev" do
    url "https://files.pythonhosted.org/packages/11/f2/404d2bfa30fb4ee7c7a7435d593f9f698b25d191cafec69dd0c726f02f11/pylev-1.4.0.tar.gz"
    sha256 "9e77e941042ad3a4cc305dcdf2b2dec1aec2fbe3dd9015d2698ad02b173006d1"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/9c/c9/a3e3bc667c8372a74aa4b16649c3466364cd84f7aacb73453c51b0c2c8a7/shellingham-1.4.0.tar.gz"
    sha256 "4855c2458d6904829bd34c299f11fdeed7cfefbf8a2c522e4caea6cd76b3171e"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/65/ed/7b7216101bc48627b630693b03392f33827901b81d4e1360a76515e3abc4/tomlkit-0.7.2.tar.gz"
    sha256 "d7a454f319a7e9bd2e249f239168729327e4dd2d27b17dc68be264ad1ce36754"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/dd/40/9bc1b32521f78c293c1f8ca423c725737dfa9d09640dbeec61cebca7c5f2/virtualenv-20.8.1.tar.gz"
    sha256 "bcc17f0b3a29670dd777d6f0755a4c04f28815395bca279cdcb213b97199a6b8"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/02/bf/0d03dbdedb83afec081fefe86cae3a2447250ef1a81ac601a9a56e785401/zipp-3.6.0.tar.gz"
    sha256 "71c644c5369f4a6e07636f0aa966270449561fcea2e3d6747b8d23efaa9d7832"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"

    vendor_site_packages = libexec/"vendor/lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages
    resources.each do |r|
      r.stage do
        system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    site_packages = libexec/"lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", site_packages
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec)

    # We don't hardcode Homebrew Python here on purpose. See
    # https://github.com/Homebrew/homebrew-core/issues/62910
    (bin/"poetry").write <<~PYTHON
      #!/usr/bin/env python3
      import sys

      sys.path.insert(0, "#{site_packages}")
      sys.path.insert(0, "#{vendor_site_packages}")

      if __name__ == "__main__":
          from poetry.console import main
          main()
    PYTHON

    # Install shell completions
    (bash_completion/"poetry").write Utils.safe_popen_read("#{libexec}/bin/poetry", "completions", "bash")
    (fish_completion/"poetry.fish").write Utils.safe_popen_read("#{libexec}/bin/poetry", "completions", "fish")
    (zsh_completion/"_poetry").write Utils.safe_popen_read("#{libexec}/bin/poetry", "completions", "zsh")
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"

    assert_match version.to_s, shell_output("#{bin}/poetry --version")
    assert_match "Created package", shell_output("#{bin}/poetry new homebrew")

    cd testpath/"homebrew" do
      system bin/"poetry", "config", "virtualenvs.in-project", "true"
      system bin/"poetry", "add", "requests"
      system bin/"poetry", "add", "boto3"
    end

    assert_predicate testpath/"homebrew/pyproject.toml", :exist?
    assert_predicate testpath/"homebrew/poetry.lock", :exist?
    assert_match "requests", (testpath/"homebrew/pyproject.toml").read
    assert_match "boto3", (testpath/"homebrew/pyproject.toml").read
  end
end
