require "language/node"

class Ntfy < Formula
  desc "Send push notifications to your phone or desktop via PUT/POST"
  homepage "https://ntfy.sh/"
  url "https://github.com/binwiederhier/ntfy/archive/v1.29.1.tar.gz"
  sha256 "da6c63312ed2f44c1684899c153065d75fbfd45801bf9aa7a701aa1d852f9a2b"
  license any_of: ["Apache-2.0", "GPL-2.0-only"]
  head "https://github.com/binwiederhier/ntfy.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "go" => :build
  depends_on "node" => :build
  uses_from_macos "sqlite" => :build

  def install
    cd "web" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build", *Language::Node.local_npm_install_args
      mv "build/index.html", "build/app.html"
    end
    rm_rf "server/site"
    mv "web/build", "server/site"
    rm "server/site/config.js"
    rm "server/site/asset-manifest.json"
    mkdir_p "server/site/static"
    mkdir_p "server/docs"
    touch "server/docs/index.html"
    touch "server/site/app.html"
    ldflags = %W[
      -linkmode=external
      -X main.version=#{version}
      -X main.date=#{time.strftime("%F")}
      -s
      -w
    ]
    with_env(
      "CGO_ENABLED" => "1",
    ) do
      system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "sqlite_omit_load_extension,osusergo,netgo"
    end
  end

  test do
    require "securerandom"
    port = free_port
    random_topic = SecureRandom.hex(6)
    begin
      pid = fork do
        exec bin/"ntfy", "serve", "--listen-http", ":"+port.to_s
      end
      sleep 1
      ntfy_in = shell_output("#{bin}/ntfy publish http://localhost:#{port}/#{random_topic} test-message")
      ohai ntfy_in
      sleep 1
      ntfy_out = shell_output("#{bin}/ntfy subscribe --poll http://localhost:#{port}/#{random_topic}")
      ohai ntfy_out
      assert_match ntfy_in, ntfy_out
    ensure
      Process.kill "SIGTERM", pid
      Process.wait pid
    end
  end
end
