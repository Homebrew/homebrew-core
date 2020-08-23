class Blogc < Formula
  desc "Blog compiler with template engine and markup language"
  homepage "https://blogc.rgm.io/"
  url "https://github.com/blogc/blogc/releases/download/v0.19.0/blogc-0.19.0.tar.xz"
  sha256 "b409deede82513448fac460c27dbfa96093c6974cf324eaf8e6ab21dc53924ef"
  license "BSD-3-Clause"
  head "https://github.com/blogc/blogc.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "118c986799974ccef116ab3b0d2cf192c0f7cdef07fceb74e3ab7b90e86b1bea" => :catalina
    sha256 "415db1c2d7555a0047940c1e7f208f1f2a9a3710bcad8a7500ba4e75b829b7ed" => :mojave
    sha256 "654dc424fae6c319b824ee1ab7beb95982ce85439ed1a90e267c2ce909aaa290" => :high_sierra
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
