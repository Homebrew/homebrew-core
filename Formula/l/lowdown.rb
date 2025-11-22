class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://github.com/kristapsdz/lowdown/archive/refs/tags/VERSION_2_0_4.tar.gz"
  sha256 "d366866f34de35a64a366efcf15dd787960ca25d986bb8780fb04a4306999eec"
  license "ISC"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5c10c8fa1e5eb3dbb8faaf67e7fc6d14f75746251949b9da220c246f0a97ef0a"
    sha256 cellar: :any,                 arm64_sequoia: "25da16e680e999d5056143dbbdfe0c8bb33c69fb8336976138e86448f18fe95f"
    sha256 cellar: :any,                 arm64_sonoma:  "f295e5c08db61418c19191b835c44f1211184f8051fd4c532759493bc57c3d84"
    sha256 cellar: :any,                 sonoma:        "ebb97e53cd7cb113b2e726ffecacc726bd4b9a463c1539806b1fc797891134b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1cdb239f485481d566a7a91586d168812c5dbda702cc23ff207b1f01fe19c8e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d85c28e32bdb68fe885de165de08ef6f3c085f5da1e6c9c91844fea8dcc1997e"
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
