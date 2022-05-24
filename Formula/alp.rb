class Alp < Formula
  desc "Access Log Profiler"
  homepage "https://github.com/tkuchiki/alp"
  url "https://github.com/tkuchiki/alp/archive/v1.0.8.tar.gz"
  sha256 "66befab0cd827fed8eeb06e18b0b0e1d4551cf7311ac8c5e15fcabf272a44c99"
  license "MIT"
  head "https://github.com/tkuchiki/alp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaabd757583812c7c7c71adc45f682928ad66a18a886f234badbe522a5c06385"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74d8563f23cfd9716a9f7b1b5ecc667f92acb7817ea881efeb0037c9ccaccef8"
    sha256 cellar: :any_skip_relocation, monterey:       "a96ee3d19dde5365dd9cbe69bc6006aecf0904a2819a4567aed8e82a3091921b"
    sha256 cellar: :any_skip_relocation, big_sur:        "909d30918325d04599ffe05aecd4b12dc3b4287367f392abc645329cdc0f57f9"
    sha256 cellar: :any_skip_relocation, catalina:       "3b5ed01c4396d31b9873f39339a6efc9663ee2968db6dbbab777f05ecc7cda84"
    sha256 cellar: :any_skip_relocation, mojave:         "03a94a2058cd2e4e889fd9064949d0164ade83cc1c6dba2ae5d0804c9e8232c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b304ced670dd2ff7ca0fc39fa82627aee5144d1375fcb9371d492cbd7641fb47"
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
