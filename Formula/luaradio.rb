class Luaradio < Formula
  desc "Lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "https://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.9.1.tar.gz"
  sha256 "25150fa6b2cfd885d59453a9c4599811573176451c659278c12d50fece69f7f3"
  license "MIT"
  revision 1
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_big_sur: "7e52830ddd8a71879d33c359971b828bc4802a10f4b8a8f176748406105d1fdf"
    sha256 cellar: :any, big_sur:       "7b03a5efbefa3aacf0d70d0c33004eef5afdcb4d5535be67d924149010fd9efa"
    sha256 cellar: :any, catalina:      "d262ff65dc4fde0c784ad364812708f845dfd5543cf893e6e616595360071046"
    sha256 cellar: :any, mojave:        "16197ba0307226d4d0dd4dbba8fc8d2a1d5a2dfe0d1ef1a8d69788eea6ddf352"
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
      LUA_CPATH: "#{lib}/lua/5.1/?.so${LUA_CPATH:+;$LUA_CPATH};;",
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
