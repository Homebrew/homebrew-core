class Blogc < Formula
  desc "Blog compiler with template engine and markup language"
  homepage "https://blogc.rgm.io/"
  url "https://github.com/blogc/blogc/releases/download/v0.20.1/blogc-0.20.1.tar.xz"
  sha256 "d1289367362b7b11b438670fe703ff2c751e795393c06e1999d6b9a6e438fdd8"
  license "BSD-3-Clause"
  head "https://github.com/blogc/blogc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff83c11472e9295479779c6e27d5ae59efb77bdb216ba4d4efb30ae88f847981" => :big_sur
    sha256 "f51d0d693775155a5eb1199a7ee90abb00e35a00a7469e02f3a31c074aff57cf" => :arm64_big_sur
    sha256 "16c4393bd90b76d031af46bcd959705ef627e49823912c543f5a76683b5b48e2" => :catalina
    sha256 "f1409e887cc77c191a561e71c497d95dffd281cdf673a5b474003902aaa44099" => :mojave
  end

  def install
    system "./configure", "--disable-tests",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-git-receiver",
                          "--enable-make",
                          "--enable-runserver",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Write config file that describes folder structure
    (testpath/"blogcfile").write <<~EOS
      [global]
      AUTHOR_NAME = Homebrew
      AUTHOR_EMAIL = brew@example.org
      SITE_TITLE = Homebrew
      SITE_TAGLINE = The Missing Package Manager for macOS (or Linux)
      BASE_DOMAIN = http://example.org

      [settings]
      locale = en_US.utf8

      [posts]
      post1
      post2
    EOS

    # Set up folder structure for a basic example site
    mkdir_p "content/post"
    mkdir_p "templates"
    (testpath/"content/post/post1.txt").write "----------\nfoo"
    (testpath/"content/post/post2.txt").write "----------\nbar"

    (testpath/"templates/main.tmpl").write <<~EOS
      <html>
      {{ SITE_TITLE }}
      {{ SITE_TAGLINE }}
      {% block listing %}{{ CONTENT }}{% endblock %}
      </html>
    EOS

    # Generate static files
    system bin/"blogc-make"

    # Run basic checks on generated files
    output = (testpath/"_build/index.html").read
    assert_match "Homebrew\nThe Missing Package Manager for macOS (or Linux)", output
    assert_match "<p>bar</p>\n<p>foo</p>", output
  end
end
