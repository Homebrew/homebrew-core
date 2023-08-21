class Alp < Formula
  desc "Access Log Profiler"
  homepage "https://github.com/tkuchiki/alp"
  url "https://github.com/tkuchiki/alp/archive/v1.0.14.tar.gz"
  sha256 "67f34c71f8cb10e3491bd0b9467cd7ff6673ddf4e26341b59d7dbe03fe44af24"
  license "MIT"
  head "https://github.com/tkuchiki/alp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8abecb19eff90b8cdd0fb0604b11c113cd17c4b03ae20d1d70fc5473c7748684"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8abecb19eff90b8cdd0fb0604b11c113cd17c4b03ae20d1d70fc5473c7748684"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8abecb19eff90b8cdd0fb0604b11c113cd17c4b03ae20d1d70fc5473c7748684"
    sha256 cellar: :any_skip_relocation, ventura:        "2d33e4f63c11310f3b541453d0e59d4573a9118a3a19f1c16a2b134e08b5c4cc"
    sha256 cellar: :any_skip_relocation, monterey:       "2d33e4f63c11310f3b541453d0e59d4573a9118a3a19f1c16a2b134e08b5c4cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d33e4f63c11310f3b541453d0e59d4573a9118a3a19f1c16a2b134e08b5c4cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04f572c0df80252f32a36f34f4f613da7adee4c4898249bde78fbc96577e04ae"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/alp"

    generate_completions_from_executable(bin/"alp", "completion")
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
