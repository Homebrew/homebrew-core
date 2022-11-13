class Luaradio < Formula
  desc "Lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "https://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.11.0.tar.gz"
  sha256 "abd6077d32a2e83ec9e4bbda1f84ccb540c9d5195d30d7a8ebeb12676e33eb2e"
  license "MIT"
  head "https://github.com/vsergeev/luaradio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "47e4144b0f5fff50e8d71da651cb24b4f04b4b7cb5d5384d6bc282f289be469c"
    sha256 cellar: :any,                 arm64_monterey: "80048889479b279f24f3f0967ea13752487ac2f9d36109999cbc86c682dac13b"
    sha256 cellar: :any,                 arm64_big_sur:  "54f0347fbb22407d85dfb361c704dbdb22edb5675e190cbdfb3d3f2d64fa1b13"
    sha256 cellar: :any,                 monterey:       "b799b23735581ff900549775dca8d0e2b37fd237f6d2062e84ac645fd3f49952"
    sha256 cellar: :any,                 big_sur:        "294b88b1809673505baf3d4d5dffa48e858ba5ef77e27f79744905aed700df07"
    sha256 cellar: :any,                 catalina:       "6e7e3d041d074853d801524198a970c6d3db8cc289ad2251b181b7c555ca53f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b11a86f2430f67c7d051d0ea2e8e6912bfa96849b4ca626cc1dbd51894a864c"
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "luajit"

  def install
    system "make", "-C", "embed", "PREFIX=#{prefix}", "INSTALL_CMOD=#{lib}/lua/5.1", "install"
  end

  test do
    (testpath/"hello").write("Hello, world!")
    (testpath/"test.lua").write <<~EOS
      local radio = require('radio')

      local PrintBytes = radio.block.factory("PrintBytes")

      function PrintBytes:instantiate()
          self:add_type_signature({radio.block.Input("in", radio.types.Byte)}, {})
      end

      function PrintBytes:process(c)
          for i = 0, c.length - 1 do
              io.write(string.char(c.data[i].value))
          end
      end

      local source = radio.RawFileSource("hello", radio.types.Byte, 1e6)
      local sink = PrintBytes()
      local top = radio.CompositeBlock()

      top:connect(source, sink)
      top:run()
    EOS

    assert_equal "Hello, world!", shell_output("#{bin}/luaradio test.lua")
  end
end
