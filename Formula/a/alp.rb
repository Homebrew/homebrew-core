class Alp < Formula
  desc "Access Log Profiler"
  homepage "https://github.com/tkuchiki/alp"
  url "https://github.com/tkuchiki/alp/archive/v1.0.17.tar.gz"
  sha256 "a9feb638f18452793cc48ff731a03bc473d418f022c57eded5834df15a6e65ff"
  license "MIT"
  head "https://github.com/tkuchiki/alp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d31301dc338ae5772b0d5706ba7121b1b7a32622d56aeeac56888a562b550e70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34860cacaa560b71e226d0808066c4cc11ae5001cf10278bf4b211f13e78bcfe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d53ff1e0d7615ba3988c67b1483b0113de3a7ae5824d9860be42a24ede19426"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49011a415c9aba887a17fc514bfd809a571eb6dbdc76e99f127d5edfdcc14f9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1ce8bcf04757293bc8b44e3c67381921bfb2e15afe40b640cbb1ed2badc5d3b"
    sha256 cellar: :any_skip_relocation, ventura:        "a54b047aa25787ae4eb5a8c963e118aa2ec35c4b5f621175f274cf8325cbd4af"
    sha256 cellar: :any_skip_relocation, monterey:       "5aab708e4292c17a296a741e1e7271c497a58b6dc5dab2ecfef8370a45820827"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a0f18dd2664e099041a9e998197bab37618695f70e659c2925dffd5886a409d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "240eac6ebbf9329bf6a22f84fe647f3e0bef5b94d119534bc38185acb6bc5f82"
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
