class Luaradio < Formula
  desc "Lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "http://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.5.1.tar.gz"
  sha256 "723dce178594a6a9a64de6ba7929f04d5fd08d0c9ed57650b22993afdb1ebdf3"
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    cellar :any
    sha256 "125167fb508f82ae680af4c3d4c574669722631ca19ad3b9b8b52f8563f29688" => :mojave
    sha256 "cf03f46947a0387cc0735a624642d90582fdb96fb843254394ab52eb1b2921ec" => :high_sierra
    sha256 "3e81ae80baacae0a53a8da520c8320513f74f6fb1552f0b3b05fa14779ac552d" => :sierra
    sha256 "8d3e797c92ceeaf64eb10c51eaef17ea56631ee4272a2e20b7bcbc4fdfb134ad" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
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
