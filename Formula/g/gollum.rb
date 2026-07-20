class Gollum < Formula
  desc "Go n:m message multiplexer"
  homepage "https://gollum.readthedocs.io/en/latest/"
  url "https://github.com/trivago/gollum/archive/refs/tags/0.6.0.tar.gz"
  sha256 "2d9e7539342ccf5dabb272bbba8223d279a256c0901e4a27d858488dd4343c49"
  license "Apache-2.0"
  head "https://github.com/trivago/gollum.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1a14fd87fbe28f9b6d56c0db996208418e6410e00385899f2d381a9602f7b8f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50cf6d3f9112bc08aa3f73561600db725179266bab393b0e3f7f891d6b4f6a7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "460291bccda886ab089032e4df6c5a289bfe1a0355fb81b10b1143200e306be6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac1e8bf4e7ddbe753112b22cf9544bbc3f1f831c8878a16c9992c194c7e35fd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ee4392902517d8c01ccefd711b89658420b8ab2727473538db2c8781e3ece6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce45eb386ab95bb215622d4c3f40811d723cc1a4278a6f829a196aff5dced632"
    sha256 cellar: :any_skip_relocation, ventura:        "201d868caa5e4eaf9ee8b0094496ea4deec2ac6fe2c6a1589baf695ebbb7be70"
    sha256 cellar: :any_skip_relocation, monterey:       "c9509e4313d50c6aa2ca636b82fd7e52dd2349d24cfd27644722bd86735ae8ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "93b409a0df8ba538dc75783b349b6e3d9d3390aa9d2e89813513a0452e3eab3e"
    sha256 cellar: :any_skip_relocation, catalina:       "a8f048a8431da205f8c35224d43b6818c73adcb1abf973e7d1274231df6cb562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9069887fd837e33a18020e839a78fa28a76f3d4088e59596e0e75941031f7760"
  end

  # no commits since july 1 2021, and cannot rebuild, https://github.com/trivago/gollum/issues/265
  deprecate! date: "2024-07-27", because: :unmaintained
  disable! date: "2025-07-27", because: :unmaintained

  depends_on "go" => :build

  def install
    # Work around https://github.com/trivago/gollum/issues/265
    mod = "github.com/CrowdStrike/go-metrics-prometheus"
    (buildpath/"vendor/#{mod}/go.mod").write <<~GOMOD
      module #{mod}
    GOMOD
    (buildpath/"go.work").write <<~EOS
      use .
      replace #{mod} => ./vendor/#{mod}
    EOS

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w -X gollum/core.versionString=#{version}")
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
