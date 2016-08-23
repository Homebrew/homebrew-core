class Emp < Formula
  desc "CLI for Empire."
  homepage "https://github.com/remind101/empire"
  url "https://github.com/remind101/empire/archive/v0.11.0.tar.gz"
  sha256 "b091b07a7f6ed15a432201fed379de4b7aec0d481b9f9323ac060683b7dacf21"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d21d95eb949b7aca853943ee4227aa26c3b8325fd48ad1277a8a30f7dcd13af" => :el_capitan
    sha256 "00637bd97dda4c10484accdb9056e378a015ec89a1b0dcf2d4cb541d42d8f106" => :yosemite
    sha256 "b65f09cab767d30c51eebf8f1994c89b73e78228ee63f0f1d35ddad9b778e2c9" => :mavericks
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
