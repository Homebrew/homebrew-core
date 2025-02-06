class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://github.com/kristapsdz/lowdown/archive/refs/tags/VERSION_2_0_0.tar.gz"
  sha256 "cad0c7eda8ce19aef4f0e261a66bceca162f9f33defd86c9ed1b243223f84b4b"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3358b72222ee75a055d1fd68c5c3a542ab5c58432270e7baa7215ea5fa564715"
    sha256 cellar: :any,                 arm64_sonoma:  "d8223bf79ad550fa24ee0a918d1484a260598d9497c78a03d7229e0f803baa4b"
    sha256 cellar: :any,                 arm64_ventura: "8f5fe8c1ebf91093f937099afa3db343fe2a6367df30db53a62883391d1cc758"
    sha256 cellar: :any,                 sonoma:        "7b9924bc80697b7576f214ea8250a3455c9fcf148047a1f669acb4ca41a9768f"
    sha256 cellar: :any,                 ventura:       "8ccd027224698f1f0bbc69b059ab114a346fddb0f2801591e26f4fb365f3a863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5588bbb354934f3325b3d38b49b9c65550a77fdc79324c09ad9f8fefbe37987d"
  end

  depends_on "bmake" => :build

  def install
    configure_args = %W[MANDIR=#{man} PREFIX=#{prefix}]
    if OS.mac?
      File.open("configure.local", "a") do |configure_local|
        configure_local.puts "HAVE_SANDBOX_INIT=0"
      end
      configure_args << "LINKER_SONAME=-install_name"
    end

    system "./configure", *configure_args
    system "bmake"
    system "bmake", "install", "install_libs"
  end

  test do
    expected_html = <<~HTML
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
    HTML
    markdown = <<~MARKDOWN
      # Title

      Hello, World
    MARKDOWN
    html = pipe_output("#{bin}/lowdown -s", markdown)
    assert_equal expected_html, html
  end
end
