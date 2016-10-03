class Luaradio < Formula
  desc "lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "http://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.4.0.tar.gz"
  sha256 "b475e0b2fe0564439dc560b65aa2da29937338d95390bb2d0873b67d0531446a"
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    cellar :any
    sha256 "e3d933241e8522c2a990a82d1953f6da56a8baf15c3105f35d543c9a81ce2fe8" => :sierra
    sha256 "5de64821ef1142e863dfdf65cde54fd8e8251735397dc2be23cf53addc69687f" => :el_capitan
    sha256 "fa5f1da92778e2f4447c85fae2ae9e745ff34eb239dd5d32789953a81f357374" => :yosemite
    sha256 "ba97b103bf71964b5c109669c7f773bdd8b0280e1a6bc14aea721fe92aff0ee7" => :mavericks
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
