class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https://github.com/cpuguy83/go-md2man"
  url "https://github.com/cpuguy83/go-md2man.git",
      :tag      => "v2.0.0",
      :revision => "f79a8a8ca69da163eee19ab442bedad7a35bba5a"

  bottle do
    cellar :any_skip_relocation
    sha256 "45c38555805dbe39ebcbb59d460c078300667aedbcd7e1111214f6a1d73dd8fe" => :mojave
    sha256 "077c724400c1b838da675ec52405d3fa348409f1a399616cbf3fd6997d48ae2a" => :high_sierra
    sha256 "ab4c25dbac6acb5f6a40c46edbe116a2cbf6435fb4281699caa9c2db5c24757d" => :sierra
  end

  depends_on "go" => :build

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/cpuguy83/go-md2man").install contents

    ENV["GOPATH"] = buildpath
    ENV["GO111MODULES"] = "enabled"

    cd gopath/"src/github.com/cpuguy83/go-md2man" do
      system "go", "build", "-o", "go-md2man"
      system "./go-md2man", "-in=go-md2man.1.md", "-out=go-md2man.1"

      bin.install "go-md2man"
      man1.install "go-md2man.1"
      prefix.install_metafiles
    end
  end

  test do
    assert_includes pipe_output(bin/"go-md2man", "# manpage\nand a half\n"),
                    ".TH manpage\n.PP\nand a half\n"
  end
end
