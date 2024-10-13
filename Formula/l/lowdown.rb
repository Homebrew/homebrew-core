class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://github.com/kristapsdz/lowdown/archive/refs/tags/VERSION_1_1_2.tar.gz"
  sha256 "2e71e6222af6043b95d6a4b737c23efa01e1750bd23db08c26abe0f2ba338403"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3aa3f96df0a34b21c2a4ecdf2aa815b403c04d0bffcfdf04a32c0b920cdbbe54"
    sha256 cellar: :any,                 arm64_sonoma:  "f656aadfe3547820928b7f0d27c5df9fe8ccd1cc2d1354642797f91561d87c23"
    sha256 cellar: :any,                 arm64_ventura: "e8113e3b0c305ea06be673f6c3b70c20cbec5c53a50e59c2421837035ed1a134"
    sha256 cellar: :any,                 sonoma:        "9a786997c5cfc7fe378b53e01b601c5c60f64d1a769a28f046740107e6d358a4"
    sha256 cellar: :any,                 ventura:       "f96b3b2b43e6001212d89b705739352162a53774d90d437d033c4e4045fa4344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66588628495f2c8330719c4f54ff031afbead18ed6f13d8fda343431b01d896e"
  end

  def install
    configure_args = %W[MANDIR=#{man} PREFIX=#{prefix}]
    if OS.mac?
      File.open("configure.local", "a") do |configure_local|
        configure_local.puts "HAVE_SANDBOX_INIT=0"
      end
      configure_args << "LINKER_SONAME=-install_name"
    end

    system "./configure", *configure_args
    system "make"
    system "make", "install", "install_libs"
  end

  test do
    expected_html = <<~EOS
      <!DOCTYPE html>
      <html>
      <head>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width,initial-scale=1" />
      <title></title>
      </head>
      <body>
      <h1 id="title">Title</h1>
      <p>Hello, World</p>
      </body>
      </html>
    EOS
    markdown = <<~EOS
      # Title

      Hello, World
    EOS
    html = pipe_output("#{bin}/lowdown -s", markdown)
    assert_equal expected_html, html
  end
end
