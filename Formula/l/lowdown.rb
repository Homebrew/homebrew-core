class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-3.1.1.tar.gz"
  sha256 "59b2cf35bf32fe602c92f33ae917a71e0b2ea76a67bbe48fbae901a8efc6fef3"
  license "ISC"
  compatibility_version 2
  head "https://github.com/kristapsdz/lowdown.git", branch: "master"

  livecheck do
    url "https://kristaps.bsd.lv/lowdown/snapshots/"
    regex(/href=.*?lowdown[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6e979fc15e9673122684946b4236d49614080f043fdbc583dc6915d3d5b851ea"
    sha256 cellar: :any, arm64_sequoia: "a89c3145a2149f876d90d5e523f50330c19c7ed623299cd0ce1963507eaa3d25"
    sha256 cellar: :any, arm64_sonoma:  "e5b4df3fdda7a9c0db7f86d8c152e1d3c97706a9207327a3dc47d409ae169985"
    sha256 cellar: :any, sonoma:        "4ae9db89997a6c1cc75bd75785c195c3d3e80db2594b801def65c07193ebce74"
    sha256 cellar: :any, arm64_linux:   "c27253a5683ec9a531639a3e90a7864f8a0c15b712fde033a6ad0b48e52a44ad"
    sha256 cellar: :any, x86_64_linux:  "3d4099aaece1ca24361ea3cbf3239e595ae8b784921887926885692498424e99"
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
