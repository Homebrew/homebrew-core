class Luaradio < Formula
  desc "Lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "https://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.10.0.tar.gz"
  sha256 "d540aac3363255c4a1f47313888d9133b037cc5d1edca0d428499a272710b992"
  license "MIT"
  head "https://github.com/vsergeev/luaradio.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b04641f0b463cd38e257f954a7b2fb49a5b4fe3ee671a5faa09f9603023f7ed2"
    sha256 cellar: :any,                 monterey:      "2789e761aa3eb0ff47516350e8e38357086cded52f1e77644ce268171fb32cec"
    sha256 cellar: :any,                 big_sur:       "765bcff473c15da215a2c162c3247c12b3a12a6a088ff324103de2e05510e973"
    sha256 cellar: :any,                 catalina:      "e0de1690d1a42741722374cc61a8966a51c9ff8219b46d5e361e06fdcf11e4b4"
    sha256 cellar: :any,                 mojave:        "535aa76ad7c009e4ffa918eb910462d861081a7516f17a2210275bb6e619ad9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3172d2fc3864696ad84bab32d36c8fb60f262a71986003b43b5a55f87fa25a7c"
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
