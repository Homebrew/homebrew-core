class Docbook < Formula
  desc "Standard SGML representation system for technical documents"
  homepage "https://docbook.org/"
  url "https://docbook.org/xml/5.0/docbook-5.0.zip"
  sha256 "3dcd65e1f5d9c0c891b3be204fa2bb418ce485d32310e1ca052e81d36623208e"

  bottle do
    cellar :any_skip_relocation
    rebuild 4
    sha256 "348f0b59ab5dff66af897a065f1bbb510ac4862adf3c46cf2a1e595e350aa1a1" => :catalina
    sha256 "8ddedcb7fc0fa34ce6f641d85fb5ed2ecc470d8bd323648bf00b571b597d3d02" => :mojave
    sha256 "6ac70ee56739ffbe8d99e18164bc42d8d0df9ce62cc2a5c55be4b65cd74092aa" => :high_sierra
    sha256 "6ac70ee56739ffbe8d99e18164bc42d8d0df9ce62cc2a5c55be4b65cd74092aa" => :sierra
    sha256 "6ac70ee56739ffbe8d99e18164bc42d8d0df9ce62cc2a5c55be4b65cd74092aa" => :el_capitan
  end

  uses_from_macos "libxml2"

  resource "xml412" do
    url "https://docbook.org/xml/4.1.2/docbkx412.zip"
    sha256 "30f0644064e0ea71751438251940b1431f46acada814a062870f486c772e7772"
    version "4.1.2"
  end

  resource "xml42" do
    url "https://docbook.org/xml/4.2/docbook-xml-4.2.zip"
    sha256 "acc4601e4f97a196076b7e64b368d9248b07c7abf26b34a02cca40eeebe60fa2"
  end

  resource "xml43" do
    url "https://docbook.org/xml/4.3/docbook-xml-4.3.zip"
    sha256 "23068a94ea6fd484b004c5a73ec36a66aa47ea8f0d6b62cc1695931f5c143464"
  end

  resource "xml44" do
    url "https://docbook.org/xml/4.4/docbook-xml-4.4.zip"
    sha256 "02f159eb88c4254d95e831c51c144b1863b216d909b5ff45743a1ce6f5273090"
  end

  resource "xml45" do
    url "https://docbook.org/xml/4.5/docbook-xml-4.5.zip"
    sha256 "4e4e037a2b83c98c6c94818390d4bdd3f6e10f6ec62dd79188594e26190dc7b4"
  end

  resource "xml50" do
    url "https://docbook.org/xml/5.0/docbook-5.0.zip"
    sha256 "3dcd65e1f5d9c0c891b3be204fa2bb418ce485d32310e1ca052e81d36623208e"
  end

  def install
    (etc/"xml").mkpath

    %w[42 412 43 44 45 50].each do |version|
      resource("xml#{version}").stage do |r|
        if version == "412"
          cp prefix/"docbook/xml/4.2/catalog.xml", "catalog.xml"

          inreplace "catalog.xml" do |s|
            s.gsub! "V4.2 ..", "V4.1.2 "
            s.gsub! "4.2", "4.1.2"
          end
        end

        rm_rf "docs"
        (prefix/"docbook/xml"/r.version).install Dir["*"]
      end
    end
  end

  def post_install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # only create catalog file if it doesn't exist already to avoid content added
    # by other formulae to be removed
    system "xmlcatalog", "--noout", "--create", "#{etc}/xml/catalog" unless File.file?("#{etc}/xml/catalog")

    %w[4.2 4.1.2 4.3 4.4 4.5 5.0].each do |version|
      catalog = prefix/"docbook/xml/#{version}/catalog.xml"

      system "xmlcatalog", "--noout", "--del",
             "file://#{catalog}", "#{etc}/xml/catalog"
      system "xmlcatalog", "--noout", "--add", "nextCatalog",
             "", "file://#{catalog}", "#{etc}/xml/catalog"
    end
  end

  def caveats; <<~EOS
    To use the DocBook package in your XML toolchain,
    you need to add the following to your ~/.bashrc:

    export XML_CATALOG_FILES="#{etc}/xml/catalog"
  EOS
  end

  test do
    assert_predicate etc/"xml/catalog", :exist?
  end
end
