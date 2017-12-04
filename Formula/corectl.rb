class Corectl < Formula
  desc "CoreOS over macOS made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.7.18.tar.gz"
  sha256 "9bdf7bc8c6a7bd861e2b723c0566d0a093ed5d5caf370a065a1708132b4ab98a"
  revision 1
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any
    sha256 "468a78c0f43c9d150313edadd23e4a373fa689243fcd0f6c48af79feb0b1854d" => :high_sierra
    sha256 "9b83542911995f649091f49cd839c949e975ae71caa220cdc224dbb86f8fd638" => :sierra
    sha256 "1d90b568db5c0ec1025b0bacb5b06b794b8e24d198cdcf036d2ff81ebd6168da" => :el_capitan
    sha256 "ae67e7433832ac259736eaa9879e18d7b724f6ffc823f487b31eb1447780f72a" => :yosemite
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

      prefix.install_metafiles
      man1.install Dir["documentation/man/*.1"]
      pkgshare.install "examples"
    end
  end

  def caveats; <<~EOS
    Starting with 0.7 "corectl" has a client/server architecture. So before you
    can use the "corectl" cli, you have to start the server daemon:

    $ corectld start

    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/corectl version")
  end
end
