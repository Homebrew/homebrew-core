class Gollum < Formula
  desc "n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/v0.5.0.tar.gz"
  sha256 "7457feb6fdeda425a8f6acd9de36c484bea37ad9e3c76c5c020668796e6e5b5a"
  head "https://github.com/trivago/gollum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3c181df987bcf277691cfd548a855cff0c985adc50a7fec1642e40b6ca78caeb" => :high_sierra
    sha256 "84d60ef65f15a9464415a163daa0cf99156c741091af926676e2954357ea4c30" => :sierra
    sha256 "cd3860265a680566dd5922dc8c9af253162be979cb800dc92878ce2ee53f2af5" => :el_capitan
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
      "Profiler":
          Type: "consumer.Profiler"
          Runs: 100000
          Batches: 100
          Characters: "abcdefghijklmnopqrstuvwxyz .,!;:-_"
          Message: "%256s"
          Streams: "profile"
          KeepRunning: false
          ModulatorRoutines: 0

      "Benchmark":
          Type: "producer.Benchmark"
          Streams: "profile"
    EOS
    assert_match "Config OK.", shell_output("#{bin}/gollum -tc #{testpath}/test.conf")
  end
end
