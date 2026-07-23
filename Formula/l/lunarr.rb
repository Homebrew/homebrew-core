class Lunarr < Formula
  desc "Self-hosted media streaming server and Plex alternative for movies and TV"
  homepage "https://github.com/lunarr-app/lunarr-go"
  url "https://github.com/lunarr-app/lunarr-go/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "55adf894ac3cfdbba3dd40791949488654cbbfe75f949cb644ff6ee6ec7ea102"
  license "Apache-2.0"
  head "https://github.com/lunarr-app/lunarr-go.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "960105105f94063e90ad24c2498f4155b93e1cb704422d900e2bcda860e1ec4b"
    sha256 cellar: :any,                 arm64_sequoia: "4f6af3be75b7455311ab6485b091ea09975422d4ea2b9e9a68aa052b98b95d4b"
    sha256 cellar: :any,                 arm64_sonoma:  "15e28e1c5a1c2b9ab31ad04a78c2ead137b11950950353c8f70722431a6bd938"
    sha256 cellar: :any,                 sonoma:        "fad54ec43ade89d1d2fb4675779bd8657558b2bc0dc8c488afde0c8205dda653"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c0c69069ef23198d17cceb496a7b8f9cc7d52289f48390d0122a9f0fecff9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a66b175dafc086d0ab903c1207cab49e827f2f02437b312f522ccb5b61d8d98d"
  end

  depends_on "ffmpeg"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    system "npm", "prune", "--omit=dev"

    # strip the foreign slice of the universal binary to satisfy `brew audit`
    deuniversalize_machos "node_modules/fsevents/fsevents.node" if OS.mac?

    # keep only the prebuilt native libraries matching this platform
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    keep = OS.mac? ? "darwin-#{arch}" : "linux-#{arch}-gnu"
    Dir["node_modules/@{libsql,seydx}/*"].each do |dir|
      rm_r(dir) unless File.basename(dir).start_with?(keep)
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
