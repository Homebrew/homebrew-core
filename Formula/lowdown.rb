class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://github.com/kristapsdz/lowdown/archive/refs/tags/VERSION_1_0_2.tar.gz"
  sha256 "049b7883874f8a8e528dc7c4ed7b27cf7ceeb9ecf8fe71c3a8d51d574fddf84b"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fb0c7d57f545fd6ed5902049ec23eaa7f54a3bde10c0e6808cc54adb76e6abb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2bc8fd2653eab9542d2afe9d6aad18481ed647dec62228d1b2e2f5a2cb03d141"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da6b18b0d4734244f9e5d677298f4a0874d87326f269656e76120d4fb867d8de"
    sha256 cellar: :any_skip_relocation, ventura:        "05886e27d8b52b8755130af5e4741f0920908d9742781975aa3cdf398ca613c3"
    sha256 cellar: :any_skip_relocation, monterey:       "a4a41ff54df94cafab6b52b1ce062cf5dbf3a99c6ad22b494c59e99bf95088b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb19bded8bdfe9220682b03c8c9aeaf7c24c86bd20d8cc294ad5cc35fba5e87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b3aae261818590324f0ed233f8f104541d5adddc0da9abe36f035919c480657"
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
    system "make", "install"
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
