class Newnode < Formula
  desc "Web proxy that uses a distributed p2p network to circumvent censorship"
  homepage "https://www.newnode.com/newnode-vpn"
  url "https://github.com/clostra/newnode.git",
    tag: "2.1.5", revision: "18a3f713267b2a08e34cbe04253df891889997a2"
  license "GPL-2.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: ["9.3", :build]
  depends_on :macos

  def install
    system "./build.sh"
    bin.install "client" => "newnode"
    path = (var/"cache/newnode")
    path.mkpath
    path.chmod 0775
  end

  service do
    run [opt_bin/"newnode", "-p", "8006"]
    keep_alive true
    working_dir var/"cache/newnode"
    log_path var/"log/newnode.log"
    error_log_path var/"log/newnode-error.log"
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"newnode", "-p", port.to_s
    end
    sleep 5

    ENV["https_proxy"] = "http://localhost:#{port}"
    begin
      system "curl", "https://brew.sh"
    ensure
      Process.kill("TERM", pid)
      begin
        Timeout.timeout(5) do
          Process.wait(pid)
        end
      rescue Timeout::Error
        Process.kill("KILL", pid) # Forcefully kill if not terminated after timeout
        Process.wait(pid)
      end
    end
  end
end
