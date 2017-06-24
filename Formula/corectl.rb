class Corectl < Formula
  desc "CoreOS over macOS made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.7.18.tar.gz"
  sha256 "9bdf7bc8c6a7bd861e2b723c0566d0a093ed5d5caf370a065a1708132b4ab98a"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a33a53383b660b70c4d90ad1e134ba7c8f9cf23987be4209945060df1a95357b" => :sierra
    sha256 "f4b1c3c1d674f973abc0d0fd7d4e7fba0053d2a52ac66a661657f98c87d9821a" => :el_capitan
    sha256 "f72de502325419a9ce2345f4372206aa56f88ecca8a96e9698d3102acfe0e0b6" => :yosemite
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
      system "opam", "install", "uri", "ocamlfind", "qcow-format", "conf-libev", "io-page<2"

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
