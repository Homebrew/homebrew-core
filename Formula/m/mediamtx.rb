class Mediamtx < Formula
  desc "Zero-dependency real-time media server and media proxy"
  homepage "https://github.com/bluenviron/mediamtx"
  # need to use the tag to generate the version info
  url "https://github.com/bluenviron/mediamtx.git",
      tag:      "v1.15.3",
      revision: "4ff80d773b6727620f74582bf8deeeb0143df4d5"
  license "MIT"
  head "https://github.com/bluenviron/mediamtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f84a05196021770e4d1857b677bb44bffc5dc2fe81610bc4f08be32c3e9712cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f84a05196021770e4d1857b677bb44bffc5dc2fe81610bc4f08be32c3e9712cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f84a05196021770e4d1857b677bb44bffc5dc2fe81610bc4f08be32c3e9712cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a673def9257eb42d34b74e65fc805cf7482447cfdcf897c308adcd9f7d24319"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb43fa01b2e6aac8db05dd5c664f47ca92e38d51aa329c407c380305d5d6c354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a169c956deca39b792f2b21a56ae072a0a8f90c1de74414bbfc36b77b477df60"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install default config
    (etc/"mediamtx").install "mediamtx.yml"
  end

  def post_install
    (var/"log/mediamtx").mkpath
  end

  service do
    run [opt_bin/"mediamtx", etc/"mediamtx/mediamtx.yml"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/mediamtx/output.log"
    error_log_path var/"log/mediamtx/error.log"
  end

  test do
    port = free_port

    # version report has some issue, https://github.com/bluenviron/mediamtx/issues/3846
    assert_match version.to_s, shell_output("#{bin}/mediamtx --help")

    mediamtx_api = "127.0.0.1:#{port}"
    pid = fork do
      exec({ "MTX_API" => "yes", "MTX_APIADDRESS" => mediamtx_api }, bin/"mediamtx", etc/"mediamtx/mediamtx.yml")
    end
    sleep 3

    # Check API output matches configuration
    curl_output = shell_output("curl --silent http://#{mediamtx_api}/v3/config/global/get")
    assert_match "\"apiAddress\":\"#{mediamtx_api}\"", curl_output
  ensure
    Process.kill("TERM", pid)
    Process.wait pid
  end
end
