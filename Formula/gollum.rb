class Gollum < Formula
  desc "n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/v0.4.5.tar.gz"
  sha256 "a1c9cf0659163d3252c1370a957f60f12e19b808ef8dd9af24cb5ee2b78bda1c"
  head "https://github.com/trivago/gollum.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8744ba1a7c88a2234b0d0ca8d5c80780c2e37e3c8081e46026af5d29aa0b1ba6" => :high_sierra
    sha256 "cc66eef01c97ff1835cba0f8020ee591ac081313aed06096e205d3cd5b4fec67" => :sierra
    sha256 "d7956cf66c1ddffb5b61e47980fd93238e950d93b125f79a295e39d7ba2c0689" => :el_capitan
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
    (testpath/"test.conf").write <<~EOS
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
