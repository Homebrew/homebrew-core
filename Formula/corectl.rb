class Corectl < Formula
  desc "CoreOS over macOS made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.7.18.tar.gz"
  sha256 "9bdf7bc8c6a7bd861e2b723c0566d0a093ed5d5caf370a065a1708132b4ab98a"
  revision 1
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any
    rebuild 2
    sha256 "b0e49f251c59fc0593f4d53d137a3c82b725bd7e78dc006bc3470602b8c27b11" => :sierra
    sha256 "9a7302ad743f222e125a1d32011d4dc0e1d134bb70bb35a267c0f7d4ecc2bd67" => :el_capitan
    sha256 "d30f6f93fd271ffbce1a800ec66965d39731830293931569e8e6d183c8c8a182" => :yosemite
  end

  depends_on "go" => :build
  depends_on "libev"
  depends_on "ocaml" => :build
  depends_on "aspcud" => :build
  depends_on "opam" => :build
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/TheNewNormal/#{name}"
    path.install Dir["*"]

    opamroot = path/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    args = []
    args << "VERSION=#{version}" if build.stable?

    cd path do
      system "opam", "init", "--no-setup"

      # Upstream issue "OCaml 4.05.0 support - cannot build in Homebrew"
      # Reported 23 Jul 2017 https://github.com/TheNewNormal/corectl/issues/119
      inreplace "opamroot/compilers/4.04.2/4.04.2/4.04.2.comp",
        '["./configure"', '["./configure" "-no-graph"'
      system "opam", "switch", "4.04.2"

      system "opam", "config", "exec", "--", "opam", "install", "uri",
             "ocamlfind", "qcow-format", "conf-libev", "io-page<2",
             "mirage-block-unix>2.3.0", "lwt<3.1.0"
      (opamroot/"system/bin").install_symlink opamroot/"4.04.2/bin/qcow-tool"
      system "opam", "config", "exec", "--", "make", "tarball", *args

      bin.install Dir["bin/*"]

      man1.install Dir["documentation/man/*.1"]
      pkgshare.install "examples"
    end
  end

  def caveats; <<-EOS.undent
    Starting with 0.7 "corectl" has a client/server architecture. So before you
    can use the "corectl" cli, you have to start the server daemon:

    $ corectld start

    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/corectl version")
  end
end
