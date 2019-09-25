class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https://github.com/cpuguy83/go-md2man"
  url "https://github.com/cpuguy83/go-md2man.git",
      :tag      => "v2.0.0",
      :revision => "f79a8a8ca69da163eee19ab442bedad7a35bba5a"

  bottle do
    cellar :any_skip_relocation
    sha256 "dabfcbfdc2279b78a9b7bc8eab1413d222d54d9b60baeed793bcbca0c73331ec" => :mojave
    sha256 "1b66811438c0517a8fccb6d7457d40273c77fa8bb11019ad2b1cc152aa3b4bd1" => :high_sierra
    sha256 "9e1e719e31ee0d563bf9d3a30ada49708d5978a015f86f9202bfb7bf3c881d20" => :sierra
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
