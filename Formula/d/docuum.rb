class Docuum < Formula
  desc "Perform least recently used (LRU) eviction of Docker images"
  homepage "https://github.com/stepchowfun/docuum"
  url "https://github.com/stepchowfun/docuum/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "fe73d257dce193c82bed9f705eab634249aca058c4cd1864da4922f31594b69b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c06e2bc1b6dd427e547b0b17b4d18e6c74811fba42b599685581e566471e641"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8213258478a3e8672223bba90f1751ab1555624c619cd1837d4556f4c1a7c6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd27f7e5b181a3e7c2723491d01985a9a124a7ed20af7a833dfb7c00541dfa31"
    sha256 cellar: :any_skip_relocation, sonoma:         "5afc7ca43a21d20380107c3346ef7025622a8ef18be94f132310e61964d26cd3"
    sha256 cellar: :any_skip_relocation, ventura:        "0568a051c93f0cbb23818c113d7c5453dc8812b660424a5f3153f50dc1f3164f"
    sha256 cellar: :any_skip_relocation, monterey:       "60571ce6d4b38795386d8ed41259bfa18242a6979e402c9e5780338ea6030b23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f9c1b16441b4bc62012fada0e9a015e56ee833d3dd2fcd563ae937e93d9b123"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  # https://github.com/stepchowfun/docuum#configuring-your-operating-system-to-run-the-binary-as-a-daemon
  service do
    run opt_bin/"docuum"
    keep_alive true
    log_path var/"log/docuum.log"
    error_log_path var/"log/docuum.log"
    environment_variables PATH: "#{std_service_path_env}:/usr/local/bin"
  end

  test do
    started_successfully = false

    Open3.popen3({ "NO_COLOR" => "true" }, "#{bin}/docuum") do |_, _, stderr, wait_thread|
      stderr.each_line do |line|
        if line.include?("Performing an initial vacuum on startup…")
          Process.kill("TERM", wait_thread.pid)
          started_successfully = true
        end
      end
    end

    assert(started_successfully, "Docuum did not start successfully.")
  end
end
