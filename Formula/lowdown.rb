class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://github.com/kristapsdz/lowdown/archive/refs/tags/VERSION_1_0_2.tar.gz"
  sha256 "049b7883874f8a8e528dc7c4ed7b27cf7ceeb9ecf8fe71c3a8d51d574fddf84b"
  license "ISC"

  def install
    if OS.mac?
      File.open("configure.local", "a") do |configure_local|
        configure_local.puts "HAVE_SANDBOX_INIT=0"
      end
      system "./configure", "LINKER_SONAME=-install_name", "MANDIR=#{man}", "PREFIX=#{prefix}"
    else
      system "./configure", "MANDIR=#{man}", "PREFIX=#{prefix}"
    end
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
    html = shell_output("echo '#{markdown}' | #{bin}/lowdown -s")
    assert_equal expected_html, html
  end
end
