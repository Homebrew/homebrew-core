class Gollum < Formula
  desc "n:m message multiplexer written in Go"
  homepage "https://github.com/trivago/gollum"
  url "https://github.com/trivago/gollum/archive/v0.5.3.tar.gz"
  sha256 "952f9b74e34b6826242d85a3625d2f181bca1b5776929b50590988c01b849afb"
  head "https://github.com/trivago/gollum.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8203d7bfc9f95ad6ea7633216a5f31c037dbd0d310ff715d31671b31dee9567" => :mojave
    sha256 "86e8ea259f024cb5c429594a4ecbafe983b06b08dc4fcad3dc35e269d89fb283" => :high_sierra
    sha256 "75fa194b9bb429eccbfeea26cde0acfb68622e0f8c544fd788fa527aad8ac322" => :sierra
    sha256 "f3b98eb14ff5762a30f55ff8da3bae13bd29cf7c684f704a3dc7ff1b334baaad" => :el_capitan
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
