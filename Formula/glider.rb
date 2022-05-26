class Glider < Formula
  desc "Forward proxy with multiple protocols support"
  homepage "https://github.com/nadoo/glider"
  url "https://github.com/nadoo/glider/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "a1c7032ad508b6c55dad3a356737cf05083441ea16a46c03f8548d4892ff9183"
  license "GPL-3.0-or-later"
  head "https://github.com/nadoo/glider.git", branch: "master"

  depends_on "go" => :build

  uses_from_macos "curl" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "."

    etc.install buildpath/"config/glider.conf.example" => "glider.conf"
  end

  service do
    run [opt_bin/"glider", "-config", etc/"glider.conf"]
    keep_alive true
  end

  test do
    proxy_port = free_port
    filename = (testpath/"test.tar.gz")
    glider = fork { exec "#{bin}/glider", "-listen", "socks5://:#{proxy_port}" }

    sleep 3
    begin
      system "curl", "--socks5", "127.0.0.1:#{proxy_port}", "-L", stable.url, "-o", filename
      filename.verify_checksum stable.checksum
    ensure
      Process.kill 9, glider
      Process.wait glider
    end
  end
end
