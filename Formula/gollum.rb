class Gollum < Formula
  desc "n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/v0.4.3.tar.gz"
  sha256 "be2a615af23dd8c716014eeddb590e6246225378b4a034682ef2a01838d318f2"
  head "https://github.com/trivago/gollum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "192fabe2a686f142e0aa156e08ee7eeccf05a39a2f1f7de0b5c3907c2573d0d2" => :el_capitan
    sha256 "611172cdba9b0be68760f38fc03e19275e07cd9b3f031895967877ff9b1c7ea9" => :yosemite
    sha256 "02f7c2fd0da3707ea9015ba0ae9645fa93387211e4eb798fbda23b10d7d12917" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/trivago/gollum").install Dir["*"]
    cd "src/github.com/trivago/gollum" do
      system "go", "build", "-o", bin/"gollum"
    end
  end

  test do
    (testpath/"test.conf").write <<-EOS.undent
    - "consumer.Profiler":
        Enable: true
        Runs: 100000
        Batches: 100
        Characters: "abcdefghijklmnopqrstuvwxyz .,!;:-_"
        Message: "%256s"
        Stream: "profile"
    EOS

    assert_match "parsed as ok", shell_output("#{bin}/gollum -tc #{testpath}/test.conf")
  end
end
