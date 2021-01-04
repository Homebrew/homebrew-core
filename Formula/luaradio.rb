class Luaradio < Formula
  desc "Lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "https://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.9.0.tar.gz"
  sha256 "8ed52290f218350f536b7d8cccb0bd4fa618fbb35e60d6f9c26a267439a6dda8"
  license "MIT"
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    cellar :any
    sha256 "5ab17c6deca1953c08081458d66faa0081b6c0c680b05e07b39563057732e90a" => :big_sur
    sha256 "1370415899d4c7c41b0bfd5ac4792ea3447736acf8727cbbe492b4214b2cc3c1" => :catalina
    sha256 "0968a0cd591fd3e3f7af909df152d5065b8b711a4a7a024c2ac13aceea9aac01" => :mojave
    sha256 "190f3227e451c188e7588e4bdd9f9b1883c97516da52386b2f7019a20858270e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "luajit"

  def install
    cd "embed" do
      # Ensure file placement is compatible with HOMEBREW_SANDBOX.
      inreplace "Makefile" do |s|
        s.gsub! "install -d $(DESTDIR)$(INSTALL_CMOD)",
                "install -d $(PREFIX)/lib/lua/5.1"
        s.gsub! "$(DESTDIR)$(INSTALL_CMOD)/radio.so",
                "$(PREFIX)/lib/lua/5.1/radio.so"
      end
      system "make", "install", "PREFIX=#{prefix}"
    end
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
