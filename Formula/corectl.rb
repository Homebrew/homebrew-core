class Corectl < Formula
  desc "CoreOS over OS X made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.7.14.tar.gz"
  sha256 "977f2090e099874122e9a66e43aee3eaec319cdcade80514f428fd5f2ab70a05"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any_skip_relocation
    sha256 "b90ea3256110447226c42fd1d20ef7b329a807a007d14ed62180ee4f17ce537d" => :el_capitan
    sha256 "ff07b9f225eaed736d72b2b0eb4f6f8cdf7bf668ebe372e16cca894ec809c906" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on :macos => :yosemite

  def install
    ENV["GOPATH"] = buildpath

    opamroot = buildpath/"opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    ENV["OPAMYES"] = "1"

    path = buildpath/"src/github.com/TheNewNormal/#{name}"
    path.install Dir["*"]

    args = []
    args << "VERSION=#{version}" if build.stable?

    cd path do
      system "opam", "init", "--no-setup"
      qcow_format_revision = build.head? ? "master" : "96db516d97b1c3ef2c7bccdac8fb6cfdcb667a04"
      system "opam", "pin", "add", "qcow-format",
        "https://github.com/mirage/ocaml-qcow.git##{qcow_format_revision}"
      system "opam", "install", "uri", "qcow-format", "ocamlfind"

      system "make", "tarball", *args

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
