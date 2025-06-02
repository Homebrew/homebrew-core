class Lowdown < Formula
  desc "Simple markdown translator"
  homepage "https://kristaps.bsd.lv/lowdown"
  url "https://github.com/kristapsdz/lowdown/archive/refs/tags/VERSION_2_0_2.tar.gz"
  sha256 "9718c0f6c99a2cef923357feced0e0f86d8047260238c5c37fd2b51ca620e373"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "72539b273d1f011b41a404ec609e5e5f90d95ecfed55de488ca96a599e7aa671"
    sha256 cellar: :any,                 arm64_sonoma:  "db56e9a27e486ab120cfb60b6c0c35906bebedbde3542c0228413bd2c7327659"
    sha256 cellar: :any,                 arm64_ventura: "682e3e2c5bb4100111aa12a3295758a33c9ef0fb688026730ba72c38d0e4a618"
    sha256 cellar: :any,                 sonoma:        "39ca5b7e92d47aedfd37487c61560c0bf81952682a2f210c75e430532ee0f3fb"
    sha256 cellar: :any,                 ventura:       "939b0d8f64b94d96ba9e865a89872d4f031b2c538fb20ba215f9be95ca3ab5d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a643fc2ad9a4c717c3a5c507cd05cd48e31a521e8d5912c753e68745f89df2ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8ccef0a88b45b09cebd38dd16dff22a85e83475e036a539cbff5c7d948dcb08"
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
