class Corectl < Formula
  desc "CoreOS over OS X made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  stable do
    url "https://github.com/TheNewNormal/corectl/archive/v0.7.0.tar.gz"
    sha256 "bdbb7d453232995c93862b7e97edb43d312f4976c84c3781e902a140c88ebb45"

    # until 0.7.1 is out
    patch do
      url "https://github.com/TheNewNormal/corectl/commit/e519a6f0d1d3c141baef631bdfc65b4e130ff60d.patch"
      sha256 "966caa8a8f0703fffb5befcc3bec546699c06ca9512d6b1739f28029fe27ed89"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bccdbdfd94b10e3b61c7b69c5420e5c5c580ac52502b6a09eec04955015c6aed" => :el_capitan
    sha256 "77bc96fd4dc2de9a6c1fb2bb736d04d698f82aa110e352c61474ed84748f89a4" => :yosemite
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
