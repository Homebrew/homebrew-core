class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-2.0.4.tar.gz"
  sha256 "37412340bc3d87dc53f2be1a161bcd8da3c1ac974f5be305b5781a56e2d02595"
  license "ISC"
  head "https://github.com/kristapsdz/lowdown.git", branch: "master"

  livecheck do
    url "https://kristaps.bsd.lv/lowdown/snapshots/"
    regex(/href=.*?lowdown[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "c04236bd938c39a042b3570751ce59bcd785e639446e5bad12f2682d9d53a0f7"
    sha256 cellar: :any,                 arm64_sequoia: "554dac119f3961941d60f4fce5ee6b1b94843c1cd7bc498613f89aa5859b2da2"
    sha256 cellar: :any,                 arm64_sonoma:  "d93128c49c43b3ba64218da11bbe9cad58a7fd26dc2d67ec4feb52b80721c68f"
    sha256 cellar: :any,                 sonoma:        "e3b7f897174e501b6f8b21e1f745ae303046ee58fff9d4e08f56223f6f9e6e5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "908dd645e5624d1078b782df0e3fe0ca7743e2b4e72ad0e6d1e394ee0da71b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "823e5e1c662198ca5437cbe9aa0425456cbf6bf49ad1c4ecda0c042bdacb0cae"
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
