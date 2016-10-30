class Gollum < Formula
  desc "n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/v0.4.4.tar.gz"
  sha256 "54e69fcf5f07b2ff543415218faafa85dd83b095a1dbf0188f4c995d6b5a87cf"
  head "https://github.com/trivago/gollum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac625b0f6a64c1fdc3aa2fc5dd5cf56dcd51760be3dfff3da6dbee6e04b9c867" => :sierra
    sha256 "80d400f2b90777eeb9ccc7d74584d10dc17227935866efc5125d4e5630953a93" => :el_capitan
    sha256 "e6879f0937f32ba566ac7be3ce5a37c767588971d13bafa27e71c381d2c51f57" => :yosemite
    sha256 "aa3dcde3d7cbea3df1738ebcce89f08c8dcce01ec5fe1693c4192c085604660b" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/trivago/gollum").install buildpath.children
    cd "src/github.com/trivago/gollum" do
      system "go", "build", "-o", bin/"gollum"
      prefix.install_metafiles
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
