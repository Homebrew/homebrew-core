class Gollum < Formula
  desc "n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/v0.5.2.tar.gz"
  sha256 "c9ab52adc6a62b81b7da8a591be7a7db71bf7122a236ff97cd456cd5fbc0ba83"
  head "https://github.com/trivago/gollum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21fe6b3a0126e7b827a8cae7d74a92bb2ae202bd91139eb8dd230acae4a353dd" => :high_sierra
    sha256 "a06fec35f228c609b6fb019f926c143d4ac058bc9877353199ba2a4f3141926b" => :sierra
    sha256 "a095c21061f6182bc7f6fefc8538e67e7a10ee535b51e3960c5a29da2de345bf" => :el_capitan
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
