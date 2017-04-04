class Gollum < Formula
  desc "n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/v0.4.5.tar.gz"
  sha256 "dd539c10b1ccb170d7d91fc063cbaef505302ed44fdf26628db82454161f38d4"
  head "https://github.com/trivago/gollum.git"

  bottle do
    sha256 "4cbfa71cec3c467f7a9b6e4405c41da06ce4876b843b688132652c04195444dd" => :sierra
    sha256 "ba5c428df17f99e83188569cddf0983daaa2c8b24e0a880e3f5f5b9fc2ca48f1" => :el_capitan
    sha256 "75f452a0422b51af5c3396f4806fb4788efbe4108eb6375c15211d5d0ead265d" => :yosemite
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
