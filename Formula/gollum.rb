class Gollum < Formula
  desc "n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/v0.5.1.tar.gz"
  sha256 "9c12feccfbe695ef9c95b1c5436916eece38221ba7c9456f5a18799ede2cec0d"
  head "https://github.com/trivago/gollum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f537437001d9d8639213232a3c4b63a88c8e32802c550eb0b0b652f2666f0c87" => :high_sierra
    sha256 "ce6bcd11eccdedad73116ef2c4fb4bfb23c85ff8c1af266cebe2ac5c37b8b9be" => :sierra
    sha256 "a10d81de20b663f86482e971d1545aaab4b5fa614110a2e8b3c8a4ab94d555ff" => :el_capitan
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
