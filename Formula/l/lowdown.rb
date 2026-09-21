class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://kristaps.bsd.lv/lowdown/snapshots/lowdown-3.2.1.tar.gz"
  sha256 "664afc7c00aadbaf16cdcf7dc464e64b529f432eba9dffc950acb0d55d1be90d"
  license "ISC"
  compatibility_version 3
  head "https://github.com/kristapsdz/lowdown.git", branch: "master"

  livecheck do
    url "https://kristaps.bsd.lv/lowdown/snapshots/"
    regex(/href=.*?lowdown[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "38a9c03bfb5c39b6d63be0274944d3b5e160a6be420940b3824f5aeea47be83d"
    sha256 cellar: :any, arm64_tahoe:       "1db06afacaaec6d74c6eab22e02640d6baf377ce2174aa58cd24dbe2610b0c73"
    sha256 cellar: :any, arm64_sequoia:     "5e8ba6edc11595adff2d93a89c7faeee42403b24a6d8659d5d3a29eba9e70260"
    sha256 cellar: :any, arm64_linux:       "f218d5b57a9de3ed769afcdd8cead044567f94c8a9eefafd2349a0aa2b10bbfd"
    sha256 cellar: :any, x86_64_linux:      "bdd9ee43b62835566b8f141d3937924c63b0c1ef565a60c749b35c9fc13551b0"
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
