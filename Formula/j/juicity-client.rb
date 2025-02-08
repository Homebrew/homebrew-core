class JuicityClient < Formula
  desc "Client app of Juicity QUIC-based proxy protocol implementation"
  homepage "https://github.com/juicity/juicity/"
  url "https://github.com/juicity/juicity/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "dab433672ef7bb209443f5f668d1cb6f704ab9ac479013c7e9416b516340ca41"
  license "AGPL-3.0-or-later"
  head "https://github.com/juicity/juicity.git", branch: "main"

  depends_on "go" => :build

  def install
    system "make", "juicity-client"
    bin.install "juicity-client"
  end

  def post_install
    (etc/"juicity").mkpath
    File.write "#{etc}/juicity/client.json", <<~EOS
      {
        "listen": ":1080",
        "server": "<ip or domain>:<port>",
        "uuid": "00000000-0000-0000-0000-000000000000",
        "password": "my_password",
        "sni": "www.example.com",
        "allow_insecure": false,
        "congestion_control": "bbr",
        "log_level": "info",
        "pinned_certchain_sha256": "aQc4fdF4Nh1PD6MsCB3eofRyfRz5R8jJ1afgr37ABZs=",
        "forward": {
          "127.0.0.1:12322": "127.0.0.1:22",
          "0.0.0.0:5201/tcp": "127.0.0.1:5201",
          "0.0.0.0:5353/udp": "8.8.8.8:53"
        }
      }
    EOS
  end

  service do
    run [opt_bin/"juicity-client", "run", "-c", etc/"juicity/client.json"]
    working_dir opt_prefix
    keep_alive true
  end

  test do
    client_port = free_port
    (testpath/"client.json").write <<~JSON
      {
        "listen": ":#{client_port}",
        "server": "127.0.0.1:#{free_port}",
        "uuid": "00000000-0000-0000-0000-000000000000",
        "password": "my_password",
        "sni": "localhost",
        "allow_insecure": true,
        "congestion_control": "bbr",
        "log_level": "info"
      }
    JSON

    assert_match "Flags", shell_output("#{bin}/juicity-client -h")
    assert_match client_port.to_s, shell_output("#{bin}/juicity-client run -c #{testpath}/client.json")
  end
end
