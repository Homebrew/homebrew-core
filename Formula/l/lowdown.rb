class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://github.com/kristapsdz/lowdown/archive/refs/tags/VERSION_1_4_0.tar.gz"
  sha256 "ee45a6270f38826490c17612c34cc8ac25269101deeca02d5d689b4bfd8f3f4c"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "181e8e0a814e4fa9725ba5fcc8631802b7b04cf88ae68adae8e28d0fc8a73b7a"
    sha256 cellar: :any,                 arm64_sonoma:  "a7397114f540a185993e0f9638a56a549d7721f34d42d3d5b919b54c1e178977"
    sha256 cellar: :any,                 arm64_ventura: "949c8543d76647936e619f147760325707d45e8f0763fc27dc3541fffaf7993b"
    sha256 cellar: :any,                 sonoma:        "8566ae59d8db1f58fe382e254fa4667f7dbe291721d6f209dffde0f3d81d4468"
    sha256 cellar: :any,                 ventura:       "bbf1cf509479e93fd209132d98eb07f85bb8a956f420de9439dda8f17184dc12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f64c8593b86e2032b5cfce2cf86d85fac19e78ab2bc4f16443d1ab52a3bb3bc"
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
