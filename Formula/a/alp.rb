class Alp < Formula
  desc "Access Log Profiler"
  homepage "https://github.com/tkuchiki/alp"
  url "https://github.com/tkuchiki/alp/archive/refs/tags/v1.0.21.tar.gz"
  sha256 "cb46bbf1c8a1feace9ea23447509a7b7fad8960e9e73948fcfdf012436c64390"
  license "MIT"
  head "https://github.com/tkuchiki/alp.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91314a180a6e144e0fc2e4d6d047c9f25b06143463961b42acf49dc625fa2660"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91314a180a6e144e0fc2e4d6d047c9f25b06143463961b42acf49dc625fa2660"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91314a180a6e144e0fc2e4d6d047c9f25b06143463961b42acf49dc625fa2660"
    sha256 cellar: :any_skip_relocation, sonoma:        "a69566f9d09559ab696fdf61867d6e885a415689684402bad741ff209406c235"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20a13083c36878ec80447a6a435651f11e3f1a6e135d1ccee55345cf007c16b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea456ac8f3f0e0fe5f469436354ab388e558be059021a5e73acef44fcef04821"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/alp"

    generate_completions_from_executable(bin/"alp", shell_parameter_format: :cobra)
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
    system bin/"alp", "json", "--file=#{testpath}/json_access.log", "--dump=#{testpath}/dump.yml"
    assert_path_exists testpath/"dump.yml"
  end
end
