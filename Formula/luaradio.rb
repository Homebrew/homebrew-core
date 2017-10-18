class Luaradio < Formula
  desc "Lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "http://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.5.0.tar.gz"
  sha256 "660b995f8fe6e62e2304647565cfecc3dc042472e514a05c1d2c0d1342565908"
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    cellar :any
    sha256 "4edb4fe949e790279a47dbb4fff762852baf034c181b50713f431d16c29e6971" => :high_sierra
    sha256 "9d1b4988ac40cde3ec5c689f1bca02d18829828ddec5e6209be102b576948fde" => :sierra
    sha256 "4c25ef01c7e0fbd08b924883a0251d6e0808cc23ccd8386d30256675797f4c80" => :el_capitan
    sha256 "126631069fc04e1a67bae61ca843f1651c80f43c5a47da59c67dba6933278458" => :yosemite
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
