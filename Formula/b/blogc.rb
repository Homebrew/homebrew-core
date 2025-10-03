class Blogc < Formula
  desc "Blog compiler with template engine and markup language"
  homepage "https://blogc.rgm.io/"
  url "https://github.com/blogc/blogc/releases/download/v0.20.1/blogc-0.20.1.tar.xz"
  sha256 "d1289367362b7b11b438670fe703ff2c751e795393c06e1999d6b9a6e438fdd8"
  license "BSD-3-Clause"
  head "https://github.com/blogc/blogc.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "54a616937c29e0fa6c68db2372e4d577e26632bf6ef9c3454f8f3571a9b28251"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1550db3be9b6c9bd21d1a522550644fbf0d524f51126ed55560c2e3d01b4444f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e277f0a14ca6504906fee7b93a4f08a9191694afa1a8eb6748a0f2bebd37bef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a042dd99d35a1bf290cf530b21adf7a248e1fc33010b64497e689c9e3ba49680"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c132ce8fffa573a857c2ce019118f46bf11b52748dc9da184f3cc42779f7cfd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f51d0d693775155a5eb1199a7ee90abb00e35a00a7469e02f3a31c074aff57cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "c00764c88556c239149297995b261c607c8f733fa90774bbf7f35cf32c9ee4b0"
    sha256 cellar: :any_skip_relocation, ventura:        "947fede34167be2c54235e21108c6bc1cf4457d1fcf6416f917a2b1aec6a5860"
    sha256 cellar: :any_skip_relocation, monterey:       "cebc47838829ba79f58cf14561233d6af355ea261206969fcb63abfe24bbf266"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff83c11472e9295479779c6e27d5ae59efb77bdb216ba4d4efb30ae88f847981"
    sha256 cellar: :any_skip_relocation, catalina:       "16c4393bd90b76d031af46bcd959705ef627e49823912c543f5a76683b5b48e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dbf177c5bfece6942cd368cee01aec2fa762f4ecc02178441d3f35d26974c03b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5188455011d94f56149adb535c9a159e925eba66e28ab4362639ebb3e72ba5ba"
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
