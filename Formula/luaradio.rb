class Luaradio < Formula
  desc "Lightweight, embeddable flow graph signal processing framework for SDR"
  homepage "https://luaradio.io/"
  url "https://github.com/vsergeev/luaradio/archive/v0.11.0.tar.gz"
  sha256 "abd6077d32a2e83ec9e4bbda1f84ccb540c9d5195d30d7a8ebeb12676e33eb2e"
  license "MIT"
  head "https://github.com/vsergeev/luaradio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2425ad1e4cc63d76223da8d3b4d3c7ce2d13eada579b4c9fb33e52714fa3d2cc"
    sha256 cellar: :any,                 arm64_monterey: "ea3c5a2a64239596ddbcedca7bf98f38a2c3e7142c0bb9e15e371394a8bc3f48"
    sha256 cellar: :any,                 arm64_big_sur:  "d8a8170a23202d459a0bc42f7f128d98bbc5ca0c683245703193250aa971663e"
    sha256 cellar: :any,                 ventura:        "32603d888a275632c553b1508ea3da7817b4264a5e9cc5754ebca63a20010867"
    sha256 cellar: :any,                 monterey:       "19dafaaeba49dfb959160cbe219045edcb4cf3b23accc5a024a09522c63d820a"
    sha256 cellar: :any,                 big_sur:        "0eb6b7bb4b742724c4edc84caec47e2409a0eeb0543d61ac4b9dc69b9e341ae7"
    sha256 cellar: :any,                 catalina:       "a4d29caa526850bfc74f55efe829e10279d840986183c2f8ff1a80a97bd6b0c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d7cf352a29e4917fb03b64ced6278562518ec30fec3a189f3e75b869f560150"
  end

  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "liquid-dsp"
  depends_on "luajit"

  def install
    system "make", "-C", "embed", "PREFIX=#{prefix}", "INSTALL_CMOD=#{lib}/lua/5.1", "install"
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
