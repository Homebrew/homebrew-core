class Gollum < Formula
  desc "n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/v0.4.4.tar.gz"
  sha256 "54e69fcf5f07b2ff543415218faafa85dd83b095a1dbf0188f4c995d6b5a87cf"
  head "https://github.com/trivago/gollum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ee6567c2ee3dc897bc5a8b35b075ce89c054336c5149cb19509b6ac16b16c71" => :el_capitan
    sha256 "852268489c1f12c0a65d3305336459ec16013adafdcc2fd3ab2ff6d1944691b3" => :yosemite
    sha256 "a79cd3bafdfc7c2d265714e6e58e395f3fe2122f74db2220ca90f1cadea16983" => :mavericks
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
