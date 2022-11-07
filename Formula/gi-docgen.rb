class GiDocgen < Formula
  include Language::Python::Virtualenv

  desc "Documentation tool for GObject-based libraries"
  homepage "https://gnome.pages.gitlab.gnome.org/gi-docgen/"
  url "https://files.pythonhosted.org/packages/4d/0d/84d2a72a79ba7874b34680cac5b81019f17d58f2b53d88f341c710f1f3cf/gi-docgen-2022.2.tar.gz"
  sha256 "fc56df0c7d4ab9e5ed83f35b7483cb07d0bf91761e4f139eed363d7e42ffe0c0"
  license any_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://gitlab.gnome.org/GNOME/gi-docgen.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7abcfcd23fa893d6387a5f9f3f67f2a1829e28c09dd33625ea701fc2d0d97073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e128ec590ba7fd3e4d80a3c159a27a916e707523f15cc747b1be718ba6d85a0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c91ccf66103d18e5588c17f3cc0b90203e79c8683bde00c9d7dd476328586c7b"
    sha256 cellar: :any_skip_relocation, monterey:       "89c4899de71503e5fd54d336b2b7eb435ffbe3fb3c4d95478b1c81f8ff80c82c"
    sha256 cellar: :any_skip_relocation, big_sur:        "81aa6da48688b43d0f7b811744bcbb5c28ab50cd0804ac6d0b79cc955f7c8f97"
    sha256 cellar: :any_skip_relocation, catalina:       "49270200ea1a463e7f620a45667203d21d92ec2ca2625b6caa9191bfc7c88b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7978df359336ed12bc4a3a8b5f3c9586814fa64c2e8806841e0ac134ce75726"
  end

  depends_on "python@3.11"

  # Source for latest version is not available on PyPI, so using GitHub tarball instead.
  # Issue ref: https://github.com/leohemsted/smartypants.py/issues/8
  resource "smartypants" do
    url "https://github.com/leohemsted/smartypants.py/archive/refs/tags/v2.0.1.tar.gz"
    sha256 "b98191911ff3b4144ef8ad53e776a2d0ad24bd508a905c6ce523597c40022773"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/85/7e/133e943e97a943d2f1d8bae0c5060f8ac50e6691754eb9dbe036b047a9bb/Markdown-3.4.1.tar.gz"
    sha256 "3b809086bb6efad416156e00a0da66fe47618a5d6918dd688f53f40c8e4cfeff"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typogrify" do
    url "https://files.pythonhosted.org/packages/8a/bf/64959d6187d42472acb846bcf462347c9124952c05bd57e5769d5f28f9a6/typogrify-2.0.7.tar.gz"
    sha256 "8be4668cda434163ce229d87ca273a11922cb1614cb359970b7dc96eed13cb38"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"brew.toml").write <<~EOS
      [library]
      description = "Homebrew gi-docgen formula test"
      authors = "Homebrew"
      license = "BSD-2-Clause"
      browse_url = "https://github.com/Homebrew/brew"
      repository_url = "https://github.com/Homebrew/brew.git"
      website_url = "https://brew.sh/"
    EOS

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
    assert_predicate testpath/"brew-1.0/index.html", :exist?
    assert_predicate testpath/"brew-1.0/struct.Formula.html", :exist?
    assert_match %r{Website.*>https://brew.sh/}, (testpath/"brew-1.0/index.html").read
    assert_match(/struct.*Formula.*{/, (testpath/"brew-1.0/struct.Formula.html").read)
  end
end
