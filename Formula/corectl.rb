class Corectl < Formula
  desc "CoreOS over OS X made very simple"
  homepage "https://github.com/TheNewNormal/corectl"
  url "https://github.com/TheNewNormal/corectl/archive/v0.7.17.tar.gz"
  sha256 "915ae2988dc57bcf7f28e0ed6c2971ae6f83879daaadbb98bef3bad0b50039e4"
  head "https://github.com/TheNewNormal/corectl.git", :branch => "golang"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff2926f719d3414d2a18313fb6963104e91d5d89826194dcc8ff63c036037c71" => :sierra
    sha256 "ea463bfffeea5970d7c46f186e9440ba28cb1e0953f620e87df5345ecf7ea6ec" => :el_capitan
    sha256 "cc5855cdd8679d87ce81f5ebce82992b9fa290848a6ba41e29ad0bdd2ba83593" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "ocaml" => :build
  depends_on "aspcud" => :build
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
      system "opam", "install", "uri", "ocamlfind", "qcow-format"

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
