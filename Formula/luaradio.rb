class Luaradio < Formula
  desc "Lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "https://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.9.1.tar.gz"
  sha256 "25150fa6b2cfd885d59453a9c4599811573176451c659278c12d50fece69f7f3"
  license "MIT"
  revision 1
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    cellar :any
    sha256 "37cc6f1e7768f09604159e620d807423ad566e5e4627d475897faf4f13bd24f5" => :big_sur
    sha256 "3d9268b432e3804d2bd01b20a5296219f491470038ef5babb5621145f06a0022" => :catalina
    sha256 "3012079cffefd761936341440ed384f7cee310930504b09b4758b0ec397737ed" => :mojave
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "luajit-openresty"

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

    env = {
      PATH:      "#{Formula["luajit-openresty"].opt_bin}:$PATH",
      LUA_PATH:  "#{lib}/lua/5.1/?.lua${LUA_PATH:+:$LUA_PATH}",
      LUA_CPATH: "#{lib}/lua/5.1/?.so${LUA_CPATH:+:$LUA_CPATH}",
    }

    bin.env_script_all_files libexec/"bin", env
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
