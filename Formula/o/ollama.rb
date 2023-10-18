class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.ai/"
  url "https://github.com/jmorganca/ollama.git",
      tag:      "v0.1.3",
      revision: "832b4db9d4baf22497145dde55f334b292ed665f"
  license "MIT"
  head "https://github.com/jmorganca/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9609a8568ed6aa68da24dd965c72c2db322b07fd93ebccbfb19ee89568a22ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75391a85dd5cbff614b550fde24ef8b9d45dfede26e446183aedfd1b407e73e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae3a915215f004b877b3a453acaad70dd2ca6b9e9e19801561d97ef210d73a97"
    sha256 cellar: :any_skip_relocation, sonoma:         "f17cf4081f056ead4b31dae96d6d2baef041fbb2344e1c73a7b924d46d077e98"
    sha256 cellar: :any_skip_relocation, ventura:        "f155f04c32ae1ac8e92a6074383acf9b58470f336e516afd47edff1a84091979"
    sha256 cellar: :any_skip_relocation, monterey:       "699f94543d1e12bcaca77a7a4e0044ba63c3c2a7f70d20223ee0a655a8098b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8252278c34004a3e2731ed658449a880fa5888970bf45f216f66ec028ce20863"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build on big sur by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version == :big_sur
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"ollama", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/ollama.log"
    error_log_path var/"log/ollama.log"
  end

  test do
    port = free_port
    ENV["OLLAMA_HOST"] = "localhost:#{port}"

    pid = fork { exec "#{bin}/ollama", "serve" }
    sleep 1
    begin
      assert_match "Ollama is running", shell_output("curl -s localhost:#{port}")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
