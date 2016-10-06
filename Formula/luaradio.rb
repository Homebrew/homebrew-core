class Luaradio < Formula
  desc "lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "http://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.4.0.tar.gz"
  sha256 "b475e0b2fe0564439dc560b65aa2da29937338d95390bb2d0873b67d0531446a"
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    cellar :any
    sha256 "d6222af64f59300f861a2db1efaec04c1d8acea37dc63dba51fd663dd194b825" => :sierra
    sha256 "9c91479f6c8481b9b9a5772082f73934128b2a9de1f146f4f5012b47a1f889d8" => :el_capitan
    sha256 "50c9ce6fd39f2d52f7f009a7240535cbd714f51381937e03a054646aa7fac4c2" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "luajit"
  depends_on "fftw" => :recommended

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
    (testpath/"test.lua").write <<-EOS.undent
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
