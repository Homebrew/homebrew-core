class Alp < Formula
  desc "Access Log Profiler"
  homepage "https://github.com/tkuchiki/alp"
  url "https://github.com/tkuchiki/alp/archive/v1.0.7.tar.gz"
  sha256 "8a7e89547ac26f7c7446ef641ab29d08bc495fc8ae707eeab57e87b4983c3262"
  license "MIT"
  head "https://github.com/tkuchiki/alp.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7809110b0e065a91816cdd2331a639a6c7c6f900c9721fa82323490b0ab34fab"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d3564f0121ee777e7360cebbf5a45681bd2f7a0e22711e407d6d16f881e80ae"
    sha256 cellar: :any_skip_relocation, catalina:      "1a79c80f62ad48e2b6759fe45df50efdc072678b35d79672d89f859d1b8a58c1"
    sha256 cellar: :any_skip_relocation, mojave:        "53b758498d52feda83dd1dcb8e5afcc7ff27492ad1655c94a030b7cbb92ac1d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c7cf21cab064633440d641f0a7cc49454771f8344d80126ebdb7656fc4a971c"
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
