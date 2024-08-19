class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://github.com/kristapsdz/lowdown/archive/refs/tags/VERSION_1_1_0.tar.gz"
  sha256 "5cc997f742fd9e3268a2bf15cb9c58bfa173b303bc13f5c61f67dedfff3bccce"
  license "ISC"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "9064bbd0e8bdcd10df4f8a1d3f8bdcd27a6224b82731e847983039ca51d3e499"
    sha256 cellar: :any,                 arm64_ventura:  "dd24024c11c3428f24dd59166bd50fc789f3772bdd6bf9240f2fdf78b06a8ba2"
    sha256 cellar: :any,                 arm64_monterey: "a4bce83c1f08f75c32fcf579793df1a50394d864b33021ecf70db2e4411a2efe"
    sha256 cellar: :any,                 sonoma:         "2f0b741ea7d64e05661184e180eed830debd898f51ec19a64b566476c8267743"
    sha256 cellar: :any,                 ventura:        "d31e6f38b70f15eac77f125317f07ec82d77130093e6519d651bfd37bf4a9293"
    sha256 cellar: :any,                 monterey:       "dae8c835158aed0264c27acc70ce419adfa26854b997700335ce89444d47c58b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c31000c8f9ff4b60b2ba703ea57231d11bfe0ad774eba558aac98c2a7aaee474"
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
