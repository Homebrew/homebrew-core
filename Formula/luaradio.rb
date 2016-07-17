class Luaradio < Formula
  desc "lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "http://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.2.0.tar.gz"
  sha256 "b2a738a10908d6d53b8ea61d50c6883b69b2b9930f769d7bc83b99464b109d93"
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    cellar :any
    sha256 "e83236648001cdbf2c1ed883c27f81ec4dc0dd28c5e0cef513bc5021b79b1790" => :el_capitan
    sha256 "fa16128c4a41780276ce1a3c9247d6fba816600d24a79900f479a8bb4391a660" => :yosemite
    sha256 "d831ef3a9e7b4f0ed3a313a90fe59fde9de4c40ab89992a8029dd983db4bff6b" => :mavericks
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
