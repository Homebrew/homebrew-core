class Ollama < Formula
  desc "Create, run, and share large language models (LLMs)"
  homepage "https://ollama.com/"
  url "https://github.com/ollama/ollama.git",
      tag:      "v0.1.32",
      revision: "fb9580df85c562295d919b6c2632117d3d8cea89"
  license "MIT"
  head "https://github.com/ollama/ollama.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bbb20b02829a3abdc34ca402a53ca5c21e93247a28fc8df3f6c5707a928b0ec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b50994ee3131494e5200b3fb209be3d6459f5dff466193ea75294f8019ba22f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2be529f80040524552af9006920d9a44f61fe2ebb9d89b6f2f26bec9eeddd2bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "7f72d348d457f7ccabcc9898363f2ceed785d151be134799af55efe6e8822790"
    sha256 cellar: :any_skip_relocation, ventura:        "1c20527dd03055da6910f21bcd843fadbfe990772f38b5c94d81615c12501d24"
    sha256 cellar: :any_skip_relocation, monterey:       "764aae5277c0d8804f2a3c301c81ff44bdaedfd857be3185e1255cf615942716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02a3c8599b948e45690607a97e1f0ef40983d81e894b67db85dacb1e0c7f1979"
  end

  depends_on "cmake" => :build
  depends_on "go" => :build

  def install
    # Fix build by setting SDKROOT
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac?
    # Fix "ollama --version"
    inreplace "version/version.go", /var Version string = "[\d.]+"/, "var Version string = \"#{version}\""

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
