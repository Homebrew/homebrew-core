class ApacheArrowGlib < Formula
  desc "GObject Introspection files of Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=arrow/arrow-0.7.1/apache-arrow-0.7.1.tar.gz"
  sha256 "f8f114d427a8702791c18a26bdcc9df2a274b8388e08d2d8c73dd09dc08e888e"
  head "https://github.com/apache/arrow.git"

  depends_on "apache-arrow"
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    cd "c_glib" do
      args = %W[
        --prefix=#{prefix}
        CC=#{ENV.cc}
      ]
      system "./configure", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    ENV["ARCHFLAGS"] = ""
    ENV["GEM_HOME"] = testpath/"gems"
    gem = "gem"
    ruby = "ruby"
    if RUBY_PLATFORM =~ /darwin(\d+)/ && Regexp.last_match(1).to_i < 17
      bindir = HOMEBREW_LIBRARY/"Homebrew/vendor/portable-ruby/current/bin"
      gem = bindir/gem
      ruby = bindir/ruby
    end
    system gem, "install", "gobject-introspection"
    system ruby, "-rgi", "-e", "GI.load('Arrow')"
  end
end
