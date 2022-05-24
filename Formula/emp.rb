class Emp < Formula
  desc "CLI for Empire"
  homepage "https://github.com/remind101/empire"
  url "https://github.com/remind101/empire/archive/v0.13.0.tar.gz"
  sha256 "1294de5b02eaec211549199c5595ab0dbbcfdeb99f670b66e7890c8ba11db22b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a2ed40bd0b729d13c28d385df50f830c92d3dd903c4634a76356d02e7f052f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfccd6cfc36dacb8a846ee189016ee6fb04b5d27a5941a225d87a4b9c44552cc"
    sha256 cellar: :any_skip_relocation, monterey:       "feac9d1b6f8545cc0b5b40c8c461c592d7ed0ce293b936dc17164b9e5bc14d01"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc362d246942141f91da093183c54a8ff679bf263f0a4326d5bed7f94cbc8f59"
    sha256 cellar: :any_skip_relocation, catalina:       "8c4bca6eca037bbef2b1a65d1974b43b36c81274e20597a76e87703ec477ee1a"
    sha256 cellar: :any_skip_relocation, mojave:         "33eafe903efc393c0964ac05ab684508b98e72a4ee2f26272ee16eee159cd514"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d96c6b3f2ee49480ddc0dac10484284e7620dce5499482bdaf12c26f42f93a13"
    sha256 cellar: :any_skip_relocation, sierra:         "2a45cd98d7345ff1872137576f97a028729ff4c0d62994d1ce6d573e3835e9db"
    sha256 cellar: :any_skip_relocation, el_capitan:     "af64990b64d29f8383db471092279e9d039c7c81b6294099bb456890b6b5161b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb37de82430eafff68026692172d7015a2a9462fbd52898980c3306fe39d74dc"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/remind101/").mkpath
    ln_s buildpath, buildpath/"src/github.com/remind101/empire"

    system "go", "build", "-o", bin/"emp", "./src/github.com/remind101/empire/cmd/emp"
  end

  test do
    require "webrick"

    server = WEBrick::HTTPServer.new Port: 8035
    server.mount_proc "/apps/foo/releases" do |_req, res|
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
      res.body = JSON.generate([resp])
    end

    Thread.new { server.start }

    begin
      ENV["EMPIRE_API_URL"] = "http://127.0.0.1:8035"
      assert_match(/v1  zab  Oct 1(1|2|3)  2015  my awesome release/,
        shell_output("#{bin}/emp releases -a foo").strip)
    ensure
      server.shutdown
    end
  end
end
