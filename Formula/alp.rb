class Alp < Formula
  desc "Access Log Profiler"
  homepage "https://github.com/tkuchiki/alp"
  url "https://github.com/tkuchiki/alp/archive/v1.0.2.tar.gz"
  sha256 "b2a0cb6b836d0f2ab9b4a53bf2ac996e18645c1332a4f0c824b6a5e12925913e"
  head "https://github.com/tkuchiki/alp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d91156919ee7610c89861004fed15b93d3f62ce5b6d3a3d24051f107d00803d2" => :catalina
    sha256 "d35149bd21dab1056af1fb2357c955751b127e286c5839f02418c779fe3d69c3" => :mojave
    sha256 "6dc7bec08da0e6c2e54f761f5a8fa2532fbdf384f592b3aa78ca7cecbd000645" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    srcpath = buildpath/"src/github.com/tkuchiki/alp"
    srcpath.install buildpath.children

    cd srcpath do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"alp", "cli/alp/main.go"
      prefix.install_metafiles
    end
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
