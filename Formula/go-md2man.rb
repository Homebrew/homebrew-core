class GoMd2man < Formula
  desc "Converts markdown into roff (man pages)"
  homepage "https://github.com/cpuguy83/go-md2man"
  url "https://github.com/cpuguy83/go-md2man.git",
      :tag      => "v1.0.10",
      :revision => "7762f7e404f8416dfa1d9bb6a8c192aa9acb4d19"

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
