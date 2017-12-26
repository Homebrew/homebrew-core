class Beets < Formula
  include Language::Python::Virtualenv
  desc "Music library manager and MusicBrainz tagger"
  homepage "http://beets.io/"
  url "https://github.com/beetbox/beets/releases/download/v1.4.6/beets-1.4.6.tar.gz"
  sha256 "62079b2338799a64e7816096c5fae3b8909fb139e4d481ec3255336e67765b50"

  option "without-fetchart", "don't install python dependencies for the fetchart plugin"
  option "with-absubmit", "install python dependencies for the absubmit plugin"
  option "with-chroma", "install python dependencies for the chroma plugin"
  option "with-discogs", "install python dependencies for the discogs plugin"
  option "with-beatport", "install python dependencies for the beatport plugin"
  option "with-lastgenre", "install python dependencies for the lastgenre plugin"
  option "with-mpdstats", "install python dependencies for the mpdstats plugin"
  option "with-web", "install python dependencies for the web plugin"
  option "with-thumbnails", "install python dependencies for the thumbnails plugin"
  option "without-ffmpeg", "don't install ffmpeg which is required by the convert plugin"

  depends_on :python3
  depends_on "ffmpeg" => :recommended

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "mutagen" do
    url "https://files.pythonhosted.org/packages/61/cb/df5b1ed5276d758684b245ecde990b05ea7470d4fa9530deb86a24cf723b/mutagen-1.39.tar.gz"
    sha256 "9da92566458ffe5618ffd26167abaa8fd81f02a7397b8734ec14dfe14e8a19e4"
  end

  resource "munkres" do
    url "https://github.com/bmc/munkres/archive/release-1.0.12.tar.gz"
    sha256 "70b3b32b4fed3b354e5c42e4d1273880a33a13ab8c108a4247140eb661767a0b"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/0e/26/6a4295c494e381d56bba986893382b5dd5e82e2643fc72e4e49b6c99ce15/Unidecode-0.04.21.tar.gz"
    sha256 "280a6ab88e1f2eb5af79edff450021a0d3f0448952847cd79677e55e58bad051"
  end

  resource "musicbrainzngs" do
    url "https://files.pythonhosted.org/packages/63/cc/67ad422295750e2b9ee57c27370dc85d5b85af2454afe7077df6b93d5938/musicbrainzngs-0.6.tar.gz"
    sha256 "28ef261a421dffde0a25281dab1ab214e1b407eec568cd05a53e73256f56adb5"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "jellyfish" do
    url "https://files.pythonhosted.org/packages/94/48/ddb1458d966f0a84e472d059d87a9d1527df7768a725132fc1d810728386/jellyfish-0.5.6.tar.gz"
    sha256 "887a9a49d0caee913a883c3e7eb185f6260ebe2137562365be422d1316bd39c9"
  end

  resource "rarfile" do
    url "https://files.pythonhosted.org/packages/de/a4/8b4abc72310da6fa53b6de8de1019e0516885d05369d6c91cba23476abe5/rarfile-3.0.tar.gz"
    sha256 "e816409e3b36794507cbe0b678bed3e4703d7412c5f7f9201a510ed6fdc66c35"
  end

  # Optional dependencies for beets plugins.

  # fetchart dependencies are recommended, since almost all beets users use fetchart.
  # metasync's dependency on dbus-python is not included here: getting dbus-python working on MacOS
  # is complicated and the MacOS Amarok userbase is neglegable. metasync does not require external
  # dependencies to work with iTunes.

  if build.with?("fetchart") || build.with?("absubmit")
    resource "requests" do
      url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
      sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
    end
  end

  if build.with? "chroma"
    resource "pyacoustid" do
      url "https://files.pythonhosted.org/packages/da/d1/bf83cce400d5513891ea52e83fde42f17299f80a380f427d50428f817a3c/pyacoustid-1.1.5.tar.gz"
      sha256 "efb6337a470c9301a108a539af7b775678ff67aa63944e9e04ce4216676cc777"
    end
  end

  if build.with? "discogs"
    resource "discogs-client" do
      url "https://files.pythonhosted.org/packages/1f/1f/62a8cee111ff72c5ad379039adef8c872813602ffd516ba35368726f14c2/discogs-client-2.2.1.tar.gz"
      sha256 "9e32b5e45cff41af8025891c71aa3025b3e1895de59b37c11fd203a8af687414"
    end
  end

  if build.with? "beatport"
    resource "requests-oauthlib" do
      url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
      sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
    end
  end

  if build.with? "lastgenre"
    resource "pylast" do
      url "https://files.pythonhosted.org/packages/8e/41/02e703a56921d1fca752c0738116952b17b3e8927cc04612c4fb9d0a9b94/pylast-2.0.0.tar.gz"
      sha256 "8e4d4962aa12d67bd357e1aa596a146b2e97afd943b5c9257e555014d13b3065"
    end
  end

  if build.with? "mpdstats"
    resource "python-mpd2" do
      url "https://files.pythonhosted.org/packages/45/1b/7d547aa74c0dc6573a069dcc3bd4c4a000725f1f0121472948d0ef3f3ab3/python-mpd2-0.5.5.tar.gz"
      sha256 "310e738c4f7ce5b5b10394ec3f182c5240dd3ec55ec59a375924c8004fbb5e51"
    end
  end

  if build.with? "web"
    resource "flask" do
      url "https://files.pythonhosted.org/packages/eb/12/1c7bd06fcbd08ba544f25bf2c6612e305a70ea51ca0eda8007344ec3f123/Flask-0.12.2.tar.gz"
      sha256 "49f44461237b69ecd901cc7ce66feea0319b9158743dd27a2899962ab214dac1"
    end

    resource "flask-cors" do
      url "https://files.pythonhosted.org/packages/64/e8/e6bcf79dcad7b7c10f8c8c35d78b5710f2ddcd8ed38e607dd6a4853ab8a8/Flask-Cors-3.0.3.tar.gz"
      sha256 "62ebc5ad80dc21ca0ea9f57466c2c74e24a62274af890b391790c260eb7b754b"
    end
  end

  if build.with? "thumbnails"
    resource "pyxdg" do
      url "https://files.pythonhosted.org/packages/26/28/ee953bd2c030ae5a9e9a0ff68e5912bd90ee50ae766871151cd2572ca570/pyxdg-0.25.tar.gz"
      sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
    end
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    venv.pip_install resources
    venv.pip_install_and_link buildpath
  end

  def caveats; <<~EOS if build.with? "absubmit"
    The absubmit plugin requires the Acousticbrainz `streaming_extractor_music`
    binary, which cannot be distributed by Homebrew.

    See http://beets.readthedocs.io/en/v1.4.6/plugins/absubmit.html for
    instructions on how to obtain this binary.
    EOS
  end

  test do
    assert_match "beets version #{version}", shell_output("#{bin}/beet version")
    assert_match "Total time:", shell_output("#{bin}/beet stats")
  end
end
