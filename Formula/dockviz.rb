class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz.git",
    :tag => "v0.6.3",
    :revision => "15f77275c4f7e459eb7d9f824b5908c165cd0ba4"
  head "https://github.com/justone/dockviz.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "01e4173f4c4fb2a240fcfba6b3a584c16bdbf41da9406494b4a1a4e757c32e41" => :high_sierra
    sha256 "f7b9d5787315ee4cd82011beae7bd7a06d322001f014de09a7a78dfd6be734e6" => :sierra
    sha256 "fed1f250e52f6eb8620de68109d7a7ee8c998b6eaf636f8850c393f040127ca9" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/justone/dockviz").install buildpath.children
    cd "src/github.com/justone/dockviz" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"dockviz"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockviz --version")
  end
end
