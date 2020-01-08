class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.8.1.tar.gz"
  sha256 "cadf9cf8038433aeeb50a777180ad4b309ac7d2fec81c7da177ddca515812f06"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "ceaa1d0df4e726017c45a50c07cb463338aebedb7ef078aaf02df7a9ba559fba" => :catalina
    sha256 "05fee70609df45e3f9ebc99df751bbe20eb373691caeb4d1e89c1d2c0c24812f" => :mojave
    sha256 "b4700186efd6ab8984bd788100b7b5e78702a7ab2bea50cf1177499ba752c191" => :high_sierra
  end

  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"

    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
