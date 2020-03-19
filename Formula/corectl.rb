class Corectl < Formula
  desc "CoreOS over macOS made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.7.18.tar.gz"
  sha256 "9bdf7bc8c6a7bd861e2b723c0566d0a093ed5d5caf370a065a1708132b4ab98a"
  revision 2
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any
    sha256 "b3d030cf97c738ef427b24cd492a7b746b738be84f234f5904eedbff14661570" => :mojave
    sha256 "74527235d27b207a4b4331f16cfbb4f5b72b1dac36f9c9a4470626c32e882d5f" => :high_sierra
    sha256 "89e963f61102d26d5fe756b06f50aa73bf9f827f81f92cefa2da6c195b7865da" => :sierra
  end

  depends_on "aspcud" => :build
  depends_on "go" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on :x11 => :build
  depends_on "libev"
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
      system "opam", "init", "--no-setup", "--disable-sandboxing"
      system "opam", "switch", "create", "ocaml-base-compiler.4.05.0"
      system "opam", "config", "exec", "--", "opam", "install", "uri.2.2.0",
             "ocamlfind.1.8.0", "qcow-format.0.5.0", "conf-libev.4-11", "io-page.1.6.1",
             "mirage-block-unix.2.4.0", "lwt.3.0.0"
      (opamroot/"system/bin").install_symlink opamroot/"ocaml-base-compiler.4.05.0/bin/qcow-tool"
      system "opam", "config", "exec", "--", "make", "tarball", *args

      bin.install Dir["bin/*"]

      prefix.install_metafiles
      man1.install Dir["documentation/man/*.1"]
      pkgshare.install "examples"
    end
  end

  def caveats
    <<~EOS
      Starting with 0.7 "corectl" has a client/server architecture. So before you
      can use the "corectl" cli, you have to start the server daemon:

      $ corectld start

    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/corectl version")
  end
end
