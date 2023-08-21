class GiDocgen < Formula
  include Language::Python::Virtualenv

  desc "Documentation tool for GObject-based libraries"
  homepage "https://gnome.pages.gitlab.gnome.org/gi-docgen/"
  url "https://files.pythonhosted.org/packages/29/72/a319bce143e5d10677bc89b66e750c1511ec005c7a8bb098b415cc68ac68/gi-docgen-2023.1.tar.gz"
  sha256 "88adeda9cbf882569479701eada009afa5d94fa29d728653ec388c32035f7fa3"
  license any_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://gitlab.gnome.org/GNOME/gi-docgen.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a07a6ee343dd01b6a02d9c434e370d8eba715b823f11127d753cfa73083f01a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "20f7770a9f981349686f2c53251a3fcecbcaf2f7d03cb389b5585924485f1917"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "951f7b180d34b2f267a6c017cbbbc4f87506aa6a425943a63d676e631fcb70a6"
    sha256 cellar: :any_skip_relocation, ventura:        "8d65cee7d820365bb9a33072e5eb87d96dec598d989d66abb2da4df724fbac3f"
    sha256 cellar: :any_skip_relocation, monterey:       "058fe642dd88f7a68fcb7101c551767a14c4db932dae0def872507129f29f2e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6b55bc3deb6b107fa5c052e920669a5fa56a3ab5a3818626aa85fb234d4218a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "812246d1f6d362897f0e60e658416cd048c66dd9e67cb5d714628c89c1fd1429"
  end

  depends_on "pygments"
  depends_on "python-markdown"
  depends_on "python-toml"
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

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "typogrify" do
    url "https://files.pythonhosted.org/packages/8a/bf/64959d6187d42472acb846bcf462347c9124952c05bd57e5769d5f28f9a6/typogrify-2.0.7.tar.gz"
    sha256 "8be4668cda434163ce229d87ca273a11922cb1614cb359970b7dc96eed13cb38"
  end

  def install
    virtualenv_install_with_resources

    # we depend on python-markdown, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    python_markdown = Formula["python-markdown"].opt_libexec
    (libexec/site_packages/"homebrew-python-markdown.pth").write python_markdown/site_packages
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
