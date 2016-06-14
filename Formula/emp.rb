require "language/go"

class Emp < Formula
  desc "CLI for Empire."
  homepage "https://github.com/remind101/empire"
  url "https://github.com/remind101/empire/archive/v0.10.1.tar.gz"
  sha256 "b1cd7ee7cb3608075071c56e83d0e3ee9faea2a98b0d406f26be9e245d8f8b2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c37f3533f55d6d82b4cf2ddbee5bd157cc5c16f336a97f65559c137c67f52c31" => :el_capitan
    sha256 "4b4b77212f95f811575352e813bf662e928a69684c18964bf17ca5cf2c6966b0" => :yosemite
    sha256 "f7f483893edd5495dbfb9dce1749b3d1568adf1ce2a12e4e771ca5cb6d6a92ab" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/remind101/").mkpath
    ln_s buildpath, buildpath/"src/github.com/remind101/empire"

    system "go", "build", "-o", bin/"emp", "./src/github.com/remind101/empire/cmd/emp"
  end

  test do
    require "webrick"
    require "utils/json"

    server = WEBrick::HTTPServer.new :Port => 8035
    server.mount_proc "/apps/foo/releases" do |_req, res|
      resp = {
        "created_at" => "2015-10-12T0:00:00.00000000-00:00",
        "description" => "my awesome release",
        "id" => "v1",
        "user" => {
          "id" => "zab",
          "email" => "zab@waba.com",
        },
        "version" => 1,
      }
      res.body = Utils::JSON.dump([resp])
    end

    Thread.new { server.start }

    begin
      ENV["EMPIRE_API_URL"] = "http://127.0.0.1:8035"
      assert_match /v1  zab  Oct 1(1|2|3) \d\d:00  my awesome release/,
        shell_output("#{bin}/emp releases -a foo").strip
    ensure
      server.shutdown
    end
  end
end
