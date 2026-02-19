class GiDocgen < Formula
  include Language::Python::Virtualenv

  desc "Documentation tool for GObject-based libraries"
  homepage "https://gnome.pages.gitlab.gnome.org/gi-docgen/"
  url "https://files.pythonhosted.org/packages/43/23/386dad008d1f1dc3c7188db63ea5bf82ceb41a5914fb050e6e09a14a457a/gi_docgen-2026.1.tar.gz"
  sha256 "65ac3c4f2b4255d1c616fb8eae55139b6ca10071545ca2272759ffd2ccf2c7b5"
  license any_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://gitlab.gnome.org/GNOME/gi-docgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "437d7007c46fd57532a7874eea65f28d4298f577d7d2778c8af9f3d99de77f63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ab6bb32f39ccd48d9ba16d254e80c64b05738aa3697b0b2429f8aee325c2b36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "947b19456bbce7b18f3c44c4440085ad3f2e57b5df80c5c967398c4f3cd954e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "913a83c34733ed2eaf31500bb9b703b3c6de0c6f641a1bfb0dbd9dbf81cd5e8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fda9036b867fcec2266cfce287d1215c086248a0525f074386e33d9b05d906a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73871760139cd48602616cc8adc3d6664b7cec8ef3909639e1b2fca0aa7892bf"
  end

  depends_on "python@3.14"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/b7/b1/af95bcae8549f1f3fd70faacb29075826a0d689a27f232e8cee315efa053/markdown-3.10.1.tar.gz"
    sha256 "1c19c10bd5c14ac948c53d0d762a04e2fa35a6d58a6b7b1e6bfcbe6fefc0001a"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "smartypants" do
    url "https://files.pythonhosted.org/packages/6c/8f/a033f78196d9467b402d100ec40b95166d43fa2642693f23f771473d8195/smartypants-2.0.2.tar.gz"
    sha256 "39d64ce1d7cc6964b698297bdf391bc12c3251b7f608e6e55d857cd7c5f800c6"
  end

  resource "typogrify" do
    url "https://files.pythonhosted.org/packages/93/8c/b73fe0050bbf67c172b7c6d0c74c356939de0e891e669667f20381c099a8/typogrify-2.1.0.tar.gz"
    sha256 "f0aa004e98032a6e6be4c9da65e7eb7150e36ca3bf508adbcda82b4d003e61ee"
  end

  def install
    virtualenv_install_with_resources
    (share/"pkgconfig").install_symlink libexec/"share/pkgconfig/gi-docgen.pc"
  end

  test do
    (testpath/"brew.toml").write <<~TOML
      [library]
      description = "Homebrew gi-docgen formula test"
      authors = "Homebrew"
      license = "BSD-2-Clause"
      browse_url = "https://github.com/Homebrew/brew"
      repository_url = "https://github.com/Homebrew/brew.git"
      website_url = "https://brew.sh/"
    TOML

    (testpath/"brew.gir").write <<~EOS
      <?xml version="1.0"?>
      <repository version="1.2"
                  xmlns="http://www.gtk.org/introspection/core/1.0"
                  xmlns:c="http://www.gtk.org/introspection/c/1.0">
        <namespace name="brew" version="1.0" c:identifier-prefixes="brew" c:symbol-prefixes="brew">
          <record name="Formula" c:type="Formula">
            <field name="name" writable="1">
              <type name="utf8" c:type="char*"/>
            </field>
          </record>
        </namespace>
      </repository>
    EOS

    output = shell_output("#{bin}/gi-docgen generate -C brew.toml brew.gir")
    assert_match "Creating namespace index file for brew-1.0", output
    assert_path_exists testpath/"brew-1.0/index.html"
    assert_path_exists testpath/"brew-1.0/struct.Formula.html"
    assert_match %r{Website.*>https://brew.sh/}, (testpath/"brew-1.0/index.html").read
    assert_match(/struct.*Formula.*{/, (testpath/"brew-1.0/struct.Formula.html").read)
  end
end
