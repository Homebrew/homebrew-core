class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.1.tar.gz"
  sha256 "15ce2a205147b8dd9da5de1ffa6e4b273ac8385959740786f7342057d0209cc3"

  bottle do
    cellar :any_skip_relocation
    sha256 "5116615e320536f120ea324599541fede442907c88718a38a7b931cf169b9616" => :sierra
    sha256 "b58ba0a732ee045be30a71559777eb297346f57f3fcde4a176c80747b0381c27" => :el_capitan
    sha256 "d096ff7f34874bc88690e716d4a2b5fe04d267ddcfcecf5aceca695e7bfbbf2d" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "foobar"
    # Testing this curses app requires a pty
    require "pty"
    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match "foobar", r.read
    end
  end
end
