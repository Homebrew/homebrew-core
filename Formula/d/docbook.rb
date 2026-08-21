class Docbook < Formula
  desc "Standard XML representation system for technical documents"
  homepage "https://docbook.org/"
  url "https://codeberg.org/DocBook/docbook/releases/download/5.2.1/docbook-5.2.1.zip"
  sha256 "c2ae23cd2b45f472d8e47c1966f5886a43a23471b066ecca6bc3a107e63e8021"
  license :cannot_represent
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: "new version should be added as a new resource"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b7417a524db49b20339879a597e192a07be149a2a9249245da83718f488c7ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b7417a524db49b20339879a597e192a07be149a2a9249245da83718f488c7ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b7417a524db49b20339879a597e192a07be149a2a9249245da83718f488c7ff"
    sha256 cellar: :any_skip_relocation, tahoe:         "ac4ff3d18c84371164a238200653bdc0356016701b58c6e1b6ed2da4cf01ee36"
    sha256 cellar: :any_skip_relocation, sequoia:       "ac4ff3d18c84371164a238200653bdc0356016701b58c6e1b6ed2da4cf01ee36"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac4ff3d18c84371164a238200653bdc0356016701b58c6e1b6ed2da4cf01ee36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b7417a524db49b20339879a597e192a07be149a2a9249245da83718f488c7ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7b7417a524db49b20339879a597e192a07be149a2a9249245da83718f488c7ff"
  end

  uses_from_macos "libxml2"

  resource "4.2" do
    url "https://archive.docbook.org/xml/4.2/docbook-xml-4.2.zip"
    sha256 "acc4601e4f97a196076b7e64b368d9248b07c7abf26b34a02cca40eeebe60fa2"
  end

  # This doesn't contain catalog.xml, so the order is intentional to use it from 4.2
  resource "4.1.2" do
    url "https://archive.docbook.org/xml/4.1.2/docbkx412.zip"
    sha256 "30f0644064e0ea71751438251940b1431f46acada814a062870f486c772e7772"
  end

  resource "4.3" do
    url "https://archive.docbook.org/xml/4.3/docbook-xml-4.3.zip"
    sha256 "23068a94ea6fd484b004c5a73ec36a66aa47ea8f0d6b62cc1695931f5c143464"
  end

  resource "4.4" do
    url "https://archive.docbook.org/xml/4.4/docbook-xml-4.4.zip"
    sha256 "02f159eb88c4254d95e831c51c144b1863b216d909b5ff45743a1ce6f5273090"
  end

  resource "4.5" do
    url "https://archive.docbook.org/xml/4.5/docbook-xml-4.5.zip"
    sha256 "4e4e037a2b83c98c6c94818390d4bdd3f6e10f6ec62dd79188594e26190dc7b4"
  end

  resource "5.0" do
    url "https://archive.docbook.org/xml/5.0/docbook-5.0.zip"
    sha256 "3dcd65e1f5d9c0c891b3be204fa2bb418ce485d32310e1ca052e81d36623208e"
  end

  resource "5.0.1" do
    url "https://archive.docbook.org/xml/5.0.1/docbook-5.0.1.zip"
    sha256 "7af9df452410e035a3707883e43039b4062f09dc2f49f2e986da3e4c0386e3c7"
  end

  resource "5.1" do
    url "https://archive.docbook.org/xml/5.1/docbook-v5.1-os.zip"
    sha256 "b3f3413654003c1e773360d7fc60ebb8abd0e8c9af8e7d6c4b55f124f34d1e7f"
  end

  resource "5.2" do
    url "https://github.com/docbook/docbook/releases/download/5.2/docbook-5.2.zip"
    sha256 "11992554a884786f1b78c6b478d6cec90352caf00bef54731c8d54f26751f2c5"
  end

  resource "5.2.1" do
    url "https://codeberg.org/DocBook/docbook/releases/download/5.2.1/docbook-5.2.1.zip"
    sha256 "c2ae23cd2b45f472d8e47c1966f5886a43a23471b066ecca6bc3a107e63e8021"
  end

  def install
    resources.each do |version|
      version.stage do |_r|
        # Copy the catalog.xml from 4.2 to 4.1.2 and update the version numbers in it.
        if version.name == "4.1.2"
          cp prefix/"docbook/xml/4.2/catalog.xml", "catalog.xml"

          inreplace "catalog.xml" do |s|
            s.gsub! "V4.2 ..", "V4.1.2 "
            s.gsub! "4.2", "4.1.2"
          end
        end

        # Move the schemas to the root of the resource directory and update catalog.xml to point to them.
        if version.name == "5.1"
          mv Dir["schemas/*"], "."
          rmdir "schemas"

          inreplace "catalog.xml", "5.1CR4", "5.1"
        end

        (prefix/"docbook/xml"/version.name).install Dir["*"]
      end
    end

    (etc/"xml").mkpath
    (libexec/"post-install").write <<~SH
      #!/bin/sh
      set -e
      catalog="#{etc}/xml/catalog"
      export XML_CATALOG_FILES="$catalog"
      xmlcatalog="$(command -v xmlcatalog)"
      [ -f "$catalog" ] || "$xmlcatalog" --noout --create "$catalog"
      for version in #{resources.map(&:name).join(" ")}; do
        entry="file://#{opt_prefix}/docbook/xml/$version/catalog.xml"
        "$xmlcatalog" --noout --del "$entry" "$catalog"
        "$xmlcatalog" --noout --add nextCatalog "" "$entry" "$catalog"
      done
    SH
    chmod 0755, libexec/"post-install"
  end

  post_install_steps do
    run "post-install", base: :libexec
  end

  def caveats
    <<~EOS
      To use the DocBook package in your XML toolchain,
      you need to add the following to your ~/.bashrc:

      export XML_CATALOG_FILES="#{etc}/xml/catalog"
    EOS
  end

  test do
    assert_path_exists etc/"xml/catalog"
  end
end
