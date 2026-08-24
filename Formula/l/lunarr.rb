class Lunarr < Formula
  desc "Self-hosted media streaming server and Plex alternative for movies and TV"
  homepage "https://github.com/lunarr-app/lunarr-go"
  url "https://github.com/lunarr-app/lunarr-go/archive/refs/tags/v0.9.4.tar.gz"
  sha256 "7f954d3acce224f43c7891172953722092ecdd4aac17befb8115b8c0d0c0ffd9"
  license "Apache-2.0"
  head "https://github.com/lunarr-app/lunarr-go.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b4cdbdbaf98950a0098bab5fcb943ce595e8d1adb2902fb24b685b0c90ff3f16"
    sha256 cellar: :any, arm64_sequoia: "716a72b9f4ebf9ba262ebc22c27362f42eaaf2772259d7adea4d7d06ef9ccb57"
    sha256 cellar: :any, arm64_sonoma:  "4501c736c69d7fcd073e6a2c2962d43246a3f2caa8e9a90942ff3e7ff817ecba"
    sha256 cellar: :any, sonoma:        "5bd31307c6dfd353c2f46c4e0ffab0af4e37e303f8e76867af149e618a1b5ccb"
    sha256 cellar: :any, arm64_linux:   "89ad8e44e7f0545c480a7b07dc2c7b3aa45b25e846e0d98503c2882092552a9f"
    sha256 cellar: :any, x86_64_linux:  "a976bb9e5b696fa0134819dd03b35e3bd2742d0a8330eb32413c59a40509dd66"
  end

  depends_on "ffmpeg"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    system "npm", "prune", "--omit=dev"

    # strip the foreign slice of the universal binary to satisfy `brew audit`
    deuniversalize_machos "node_modules/fsevents/fsevents.node" if OS.mac?

    # keep only the prebuilt native libraries matching this platform;
    # @libsql suffixes the libc (`darwin-arm64`, `linux-arm64-gnu`) while
    # @seydx/node-av prefixes the package name (`node-av-darwin-arm64`)
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os_arch = OS.mac? ? "darwin-#{arch}" : "linux-#{arch}"
    Dir["node_modules/@{libsql,seydx}/*"].each do |dir|
      base = File.basename(dir)
      rm_r(dir) unless base.end_with?(os_arch, "#{os_arch}-gnu")
    end

    libexec.install Dir["*"]
    (bin/"lunarr").write_env_script formula_opt_bin("node")/"node", libexec/"scripts/start.mjs",
                                    NODE_ENV:    "production",
                                    FFMPEG_PATH: formula_opt_bin("ffmpeg")/"ffmpeg"
  end

  service do
    run [opt_bin/"lunarr"]
    keep_alive true
    environment_variables LUNARR_DATA_DIR: var/"lunarr"
    log_path var/"log/lunarr.log"
    error_log_path var/"log/lunarr.log"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lunarr --version").strip

    port = free_port
    ENV["LUNARR_DATA_DIR"] = (testpath/"data").to_s
    ENV["PORT"] = port.to_s
    pid = spawn bin/"lunarr"
    begin
      output = shell_output("curl --silent --retry 10 --retry-connrefused --retry-delay 3 " \
                            "http://127.0.0.1:#{port}/api/health")
      assert_match "\"ok\":true", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
