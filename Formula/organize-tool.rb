class OrganizeTool < Formula
  include Language::Python::Virtualenv

  desc "File management automation tool"
  homepage "https://github.com/tfeldmann/organize"
  url "https://files.pythonhosted.org/packages/9c/f9/5a2e51fd2d5880d8fd9ac29fe34c9c9311646cb008f55f4a8a449f69998a/organize-tool-2.4.0.tar.gz"
  sha256 "c18e10be627ce09176beddedd3d6873c4b58690146a64bb914f41db212d17932"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd4200f30ffadbe37f90227762064f21b83290df7b27b5a48c3d23699ea4e87d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "371c5ad233362931903b33df7eac359366a3026784ef6ccb01fcdaaf90b8cca8"
    sha256 cellar: :any_skip_relocation, monterey:       "663766a3bc1331ee2d21eaed5c300bcbbdf8e8e0f6b75e18a6751afbaad25290"
    sha256 cellar: :any_skip_relocation, big_sur:        "b41ce406bb75c97fc8155af671a6c9156ce954160070ed21c836aa691ca9b9e6"
    sha256 cellar: :any_skip_relocation, catalina:       "295d42141511cc4379e6407a060b8f4b9f4004713b7a19d9cf694bc8383fabbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40b49df117ed7262556ec5247017874c499baf664e2d3f82eaca9a46c1612a9b"
  end

  depends_on "freetype"
  depends_on "openjpeg"
  depends_on "pygments"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "ExifRead" do
    url "https://files.pythonhosted.org/packages/20/64/e8f40966ca766173fe57cc4de7d35492cf18949ced8b612924d48fa1d297/ExifRead-3.0.0.tar.gz"
    sha256 "0ac5a364169dbdf2bd62f94f5c073970ab6694a3166177f5e448b10c943e2ca4"
  end

  resource "fs" do
    url "https://files.pythonhosted.org/packages/5d/a9/af5bfd5a92592c16cdae5c04f68187a309be8a146b528eac3c6e30edbad2/fs-2.4.16.tar.gz"
    sha256 "ae97c7d51213f4b70b6a958292530289090de3a7e15841e108fbe144f069d313"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/bb/2d/c902484141330ded63c6c40d66a9725f8da5e818770f67241cf429eef825/rich-12.5.1.tar.gz"
    sha256 "63a5c5ce3673d3d5fbbf23cd87e11ab84b6b451436f1b7f19ec54b6bc36ed7ca"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "Send2Trash" do
    url "https://files.pythonhosted.org/packages/49/2c/d990b8d5a7378dde856f5a82e36ed9d6061b5f2d00f39dc4317acd9538b4/Send2Trash-1.8.0.tar.gz"
    sha256 "d2c24762fd3759860a0aff155e45871447ea58d2be6bdd39b5c8f966a0c99c2d"
  end

  resource "simplematch" do
    url "https://files.pythonhosted.org/packages/1a/3d/4504e218fe50c988c8229fe4bfd5633ed43e1fa79de7147c5ddfec270fae/simplematch-1.3.tar.gz"
    sha256 "ed1d17d842799ee2222de1ea5f7fc3b4b1317464852214dc7dd197c1332a9f3c"
  end

  def install
    venv = virtualenv_create(libexec, "python3.10")
    dependencies = resources.map(&:name).to_set
    if OS.linux?
      # `macos-tags` and its dependencies are only needed on macOS
      # TODO: Currently requires manual check to confirm PyPI dependency tree
      dependencies -= %w[macos-tags mdfind-wrapper xattr cffi pycparser]
      # Same for `pyobjc-framework-cocoa` and its dependencies
      dependencies -= %w[pyobjc-framework-Cocoa pyobjc-core]
    end
    dependencies.each do |r|
      venv.pip_install resource(r)
    end
    venv.pip_install_and_link buildpath
  end

  test do
    config_file = testpath/"config.yaml"
    config_file.write <<~EOS
      rules:
        - locations: #{testpath}
          filters:
            - extension: txt
          actions:
            - echo: 'Found: {path.name}'
            - delete
    EOS

    touch testpath/"homebrew.txt"

    assert_match "Found: homebrew.txt", shell_output("#{bin}/organize sim #{config_file}")
    system bin/"organize", "run", config_file
    refute_predicate testpath/"homebrew.txt", :exist?
  end
end
