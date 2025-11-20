class Emp < Formula
  desc "CLI for Empire"
  homepage "https://github.com/remind101/empire"
  url "https://github.com/remind101/empire/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "1294de5b02eaec211549199c5595ab0dbbcfdeb99f670b66e7890c8ba11db22b"
  license "BSD-2-Clause"
  head "https://github.com/remind101/empire.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "dc3eb6648c8443b68ca7a35aa21bf16d28d07cb8f82bfe1b1cb0b0c3dc3777e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7ef67fd96c5a64e80725b692c1aee910be954a1b176304d2286d1c55d3c40df2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "382fd0ca04a5ba7096e40659a951bcc592c81dad66dc4678b6048404db8de7b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "292441699541a16506dbbaae20b3893bcc9a0a10d8630c321930232657feed06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a2ed40bd0b729d13c28d385df50f830c92d3dd903c4634a76356d02e7f052f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfccd6cfc36dacb8a846ee189016ee6fb04b5d27a5941a225d87a4b9c44552cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "acef949baddb2d680bdddabd02cb764e97b291eb5c17933f1827b97be6392518"
    sha256 cellar: :any_skip_relocation, ventura:        "f24039f8d422c330ecb050b546bf5a87f7178fa5b0d2b0503086151f001edf5b"
    sha256 cellar: :any_skip_relocation, monterey:       "feac9d1b6f8545cc0b5b40c8c461c592d7ed0ce293b936dc17164b9e5bc14d01"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc362d246942141f91da093183c54a8ff679bf263f0a4326d5bed7f94cbc8f59"
    sha256 cellar: :any_skip_relocation, catalina:       "8c4bca6eca037bbef2b1a65d1974b43b36c81274e20597a76e87703ec477ee1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c8806e9c22c0e67d032dc91eda01f8d7fbb48789cf01cf824fca5fccd031dfa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb37de82430eafff68026692172d7015a2a9462fbd52898980c3306fe39d74dc"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/remind101/").mkpath
    ln_s buildpath, buildpath/"src/github.com/remind101/empire"

    system "go", "build", *std_go_args, "./src/github.com/remind101/empire/cmd/emp"
  end

  test do
    port = free_port

    # Mock an API server response to test the CLI
    fork do
      server = TCPServer.new(port)
      resp = {
        "created_at"  => "2015-10-12T0:00:00.00000000-00:00",
        "description" => "my awesome release",
        "id"          => "v1",
        "user"        => {
          "id"    => "zab",
          "email" => "zab@waba.com",
        },
        "version"     => 1,
      }
      body = JSON.generate([resp])

      loop do
        socket = server.accept
        socket.write "HTTP/1.1 200 OK\r\n" \
                     "Content-Type: application/json; charset=utf-8\r\n" \
                     "Content-Length: #{body.bytesize}\r\n" \
                     "\r\n"
        socket.write body
        socket.close
      end
    end

    sleep 1

    ENV["EMPIRE_API_URL"] = "http://127.0.0.1:#{port}"
    assert_match(/v1  zab  Oct 1(1|2|3)  2015  my awesome release/,
      shell_output("#{bin}/emp releases -a foo").strip)
  end
end
