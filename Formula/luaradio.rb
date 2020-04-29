class Luaradio < Formula
  desc "Lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "https://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.7.0.tar.gz"
  sha256 "7414c7bafc4ca3a9b0ac33e436987080602df53d0476f3618f0f37801e854aa6"
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    cellar :any
    sha256 "063266ad5c45680d857f886b56bb7433ab7c1a773faf913a9a65f2438cab19e0" => :catalina
    sha256 "39ee06b5e709130ccf45c02dac4a4bd24e77ac8c2a45ab861047cc1f4038cc09" => :mojave
    sha256 "2b877ed01320a66f0b12a2303ec93caf93abadbde8da1ad724f11403a0b2ec10" => :high_sierra
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
