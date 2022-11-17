class Alp < Formula
  desc "Access Log Profiler"
  homepage "https://github.com/tkuchiki/alp"
  url "https://github.com/tkuchiki/alp/archive/v1.0.12.tar.gz"
  sha256 "68a0066381673c8857adbf55b18fc472f861e39f33571ad130bde59698f2d043"
  license "MIT"
  head "https://github.com/tkuchiki/alp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d79a6e1374f64c0cdd5eaad9153c9149a23f01d4821b0c1706cc3d3743fd4977"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33275215bbb389a501355137dad8f4ec4ad2a6eae61e019fae7c5aa5f3909d82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6690ae8f1da8ddfa6f63d08ded015fcdee942fd4f03dd6f75985293394830603"
    sha256 cellar: :any_skip_relocation, ventura:        "9a22777557141203c21a40ab2b78310620e6438697160f9bf62dae9ee85df8d2"
    sha256 cellar: :any_skip_relocation, monterey:       "a62c5786804ab1159618834453570f07b221e2988470adadd7c221bfc7163c38"
    sha256 cellar: :any_skip_relocation, big_sur:        "c290641a54c5eff3f5b46374bd2bcd779c15a4c39a013b04fd3ff563d9f616fb"
    sha256 cellar: :any_skip_relocation, catalina:       "ba7a5d3564a69a7f82df753d4728df98e83d00223ec3556de7867a4bcf3e0525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d72452d6a5d15c2a91186957f3d1febb2236303d7536eb2586c6153deb8d412f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"alp", "cli/alp/main.go"
    prefix.install_metafiles
  end

  test do
    (testpath/"json_access.log").write <<~EOS
      {"time":"2015-09-06T05:58:05+09:00","method":"POST","uri":"/foo/bar?token=xxx&uuid=1234","status":200,"body_bytes":12,"response_time":0.057}
      {"time":"2015-09-06T05:58:41+09:00","method":"POST","uri":"/foo/bar?token=yyy","status":200,"body_bytes":34,"response_time":0.100}
      {"time":"2015-09-06T06:00:42+09:00","method":"GET","uri":"/foo/bar?token=zzz","status":200,"body_bytes":56,"response_time":0.123}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/foo/bar","status":400,"body_bytes":15,"response_time":"-"}
      {"time":"2015-09-06T05:58:44+09:00","method":"POST","uri":"/foo/bar?token=yyy","status":200,"body_bytes":34,"response_time":0.234}
      {"time":"2015-09-06T05:58:44+09:00","method":"POST","uri":"/hoge/piyo?id=yyy","status":200,"body_bytes":34,"response_time":0.234}
      {"time":"2015-09-06T05:58:05+09:00","method":"POST","uri":"/foo/bar?token=xxx&uuid=1234","status":200,"body_bytes":12,"response_time":0.057}
      {"time":"2015-09-06T05:58:41+09:00","method":"POST","uri":"/foo/bar?token=yyy","status":200,"body_bytes":34,"response_time":0.100}
      {"time":"2015-09-06T06:00:42+09:00","method":"GET","uri":"/foo/bar?token=zzz","status":200,"body_bytes":56,"response_time":0.123}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/foo/bar","status":400,"body_bytes":15,"response_time":"-"}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/diary/entry/1234","status":200,"body_bytes":15,"response_time":0.135}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/diary/entry/5678","status":200,"body_bytes":30,"response_time":0.432}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/foo/bar/5xx","status":504,"body_bytes":15,"response_time":60.000}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/req","status":200,"body_bytes":15,"response_time":"-", "request_time":0.321}
    EOS
    system "#{bin}/alp", "json", "--file=#{testpath}/json_access.log", "--dump=#{testpath}/dump.yml"
    assert_predicate testpath/"dump.yml", :exist?
  end
end
