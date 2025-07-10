class Metanorma < Formula
  desc "Toolchain for publishing metanorma documentation"
  homepage "https://www.metanorma.com"
  url "https://github.com/metanorma/metanorma-cli/archive/refs/tags/v1.12.8.tar.gz"
  sha256 "92f5b0f0675d260cdebc29685e205af912116b0fa18f4a3dbf203df23f82c528"
  license "BSD-2-Clause"

  depends_on "pkgconf" => :build
  depends_on "gflags"
  depends_on "graphviz"
  depends_on "openjdk"
  depends_on "plantuml"
  depends_on "readline"
  depends_on "ruby@3.3" # default ruby 2.6 is not supported
  depends_on "xml2rfc"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libxslt"
  end

  resource "gemfile-lock" do
    url "https://github.com/metanorma/metanorma-cli/releases/download/v1.12.8/Gemfile.lock"
    sha256 "d5abc46cdde32a1707736f76db4a2a5da4727ea78dcef59003f514ccd1ba5240"
  end

  resource "gemfile" do
    url "https://rubygems.org/downloads/metanorma-cli-1.12.8.gem"
    sha256 "b746637b00a051ca409ccf98fc82c12c443d27183c3d4bdd3535ad47eb015573"
  end

  def install
    ENV["BUNDLE_VERSION"] = "system" # Avoid installing Bundler into the keg
    ENV["GEM_HOME"] = libexec

    # Ensure Ruby 3.3 is used
    ENV.prepend_path "PATH", Formula["ruby@3.3"].opt_bin

    # Unpack the gemfile-lock and gemfile (to be shipped with the source code in future releases)
    resources.each do |r|
      r.stage do
        cp_r ".", buildpath
      end
    end
    # Remove the metanorma GitHub source block
    regex = %r{
      source\s+"https://rubygems\.pkg\.github\.com/metanorma"\s+do\s+
      gem\s+"metanorma-nist"\s+
      end\n?
    }mx
    inreplace "Gemfile", regex, ""

    # Configure sqlite3 to use brew's libsqlite3
    sqlite = Formula["sqlite"]
    system "bundle", "config", "build.sqlite3",
           "--enable-system-libraries",
           "--with-sqlite3-include=#{sqlite.opt_include}",
           "--with-sqlite3-lib=#{sqlite.opt_include}"

    if OS.linux?
      # Configure pngcheck to use brew's zlib (libz.so.1)
      zlib = Formula["zlib"]
      ENV.append "CFLAGS", "-I#{zlib.opt_include}"
      ENV.append "LDFLAGS", "-L#{zlib.opt_lib} -Wl,-rpath,#{zlib.opt_lib}"
      ENV.append "PKG_CONFIG_PATH", "#{zlib.opt_lib}/pkgconfig"
    end

    system "bundle", "config", "set", "without", "development", "test"
    system "bundle", "install"
    system "gem", "build", "metanorma-cli.gemspec"
    system "gem", "install", "metanorma-cli-#{version}.gem"

    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(
      libexec/"bin",
      PATH:      "#{Formula["ruby@3.3"].opt_bin}:$PATH",
      GEM_HOME:  ENV["GEM_HOME"],
      JAVA_HOME: Language::Java.overridable_java_home_env[:JAVA_HOME],
    )
  end

  def caveats
    <<~EOS
      inkscape >= 1.0 is required to generate Word output using SVG images.
      Install it by running `brew cask install inkscape` or
      directly download from https://inkscape.org/release/inkscape-1.0/
    EOS
  end

  test do
    test_doc = <<~ADOC
      = Document title
      Author
      :docfile: test.adoc
      :nodoc:
      :novalid:
      :no-isobib:
    ADOC

    (testpath / "test-iso.adoc").write(test_doc)
    system bin/"metanorma", "--type", "iso", testpath / "test-iso.adoc",
           "--agree-to-terms"
    assert_path_exists testpath / "test-iso.xml"
    assert_path_exists testpath / "test-iso.html"

    (testpath / "test-csa.adoc").write(test_doc)
    system bin/"metanorma", "--type", "csa", testpath / "test-csa.adoc",
           "--agree-to-terms"
    assert_path_exists testpath / "test-csa.pdf"
    assert_path_exists testpath / "test-csa.html"
  end
end
