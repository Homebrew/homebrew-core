class NewnodeHelper < Formula
  desc "Web proxy that uses a distributed p2p network to circumvent censorship"
  homepage "https://www.newnode.com/newnode-vpn"
  url "https://github.com/clostra/newnode.git",
    tag: "2.1.4", revision: "c42a04ded55cfdff857878f4d9234950e530bb00"
  license "GPL-2.0-only"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "libtool" => :build
  depends_on "mbedtls@2" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: ["9.3", :build]
  depends_on :macos

  def install
    system "./build.sh"
    bin.install "client" => "newnode-helper"
    path = (var/"newnode-helper")
    path.mkpath
    path.chmod 0775
  end

  service do
    run [opt_bin/"newnode-helper", "-p", "8006"]
    keep_alive true
    working_dir var/"newnode-helper"
    log_path var/"log/newnode-helper.log"
    error_log_path var/"log/newnode-helper-error.log"
  end

  test do
    # use wget to try to download a file via the newnode's HTTP proxy
    # if that works, newnode vpn is working
    pid = fork do
      exec "#{opt_bin}/newnode-helper", "-p", "8006"
    end
    sleep 5

    ENV["https_proxy"] = "http://localhost:8006"
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
