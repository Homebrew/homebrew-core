class GiDocgen < Formula
  include Language::Python::Virtualenv

  desc "Documentation tool for GObject-based libraries"
  homepage "https://gnome.pages.gitlab.gnome.org/gi-docgen/"
  url "https://files.pythonhosted.org/packages/49/03/b3202f4ae48f70db6c90402adf3350a8931034099ac6a006c5695d5e4740/gi_docgen-2025.4.tar.gz"
  sha256 "7fe066da082a4edcf924063767404f9d04a998f6c0f0c475b180fd9823a72dc5"
  license any_of: ["Apache-2.0", "GPL-3.0-or-later"]
  head "https://gitlab.gnome.org/GNOME/gi-docgen.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e25a47e7b56e4b7a2c1d2aad115f563225309329c75cd7c1eee3d19a5bb4e90c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fe5b7cee17c264440cbfb6ecc9890f06a5bbf6a4df34b893b341067e2ea0eab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c885badbbcd109726793c5b980f5018911a63df61f3516100b5c4386f23dd67"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4635ee03be989f41ee90cdfe48367e323ae4d1058b2fdb5fb83135b1d0f4a44a"
    sha256 cellar: :any_skip_relocation, sonoma:        "322959c1fc686664aa93838da8afb5ed1478bb2301bb359920b7b745c84bc5fe"
    sha256 cellar: :any_skip_relocation, ventura:       "2c4933d7cfe156d908b0a9bb4aa0d0668150e1c37b9c806194d69bfc352fa5d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "572510d350e49c62d6fa71c260b5d755f1b81915e7312b0f35d5ac4eddd7c28d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f53894500f08d8e9c84d14feea2322a6a93c5009fcde03a5693454d2a4c387d"
  end

  depends_on "python@3.13"

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/d7/c2/4ab49206c17f75cb08d6311171f2d65798988db4360c4d1485bd0eedd67c/markdown-3.8.2.tar.gz"
    sha256 "247b9a70dd12e27f67431ce62523e675b866d254f900c4fe75ce3dda62237c45"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
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
