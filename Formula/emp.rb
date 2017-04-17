class Emp < Formula
  desc "CLI for Empire."
  homepage "https://github.com/remind101/empire"
  url "https://github.com/remind101/empire/archive/v0.12.0.tar.gz"
  sha256 "fffffb10966b2eedcc5518c69c765b459d9a9f55d41d9c7735e744eff3960b61"

  bottle do
    cellar :any_skip_relocation
    sha256 "885c908a7345e391f18ddaa31f557a804f002c51ed380ecd30250292e98b61b5" => :sierra
    sha256 "32758cf97cbe3cdd364e0a9186c11bf85711e505114bf69e00e3b0243853a050" => :el_capitan
    sha256 "6fe53748cc8bcaa2f326ccf55b4217ead05cee5030d7f7bfb80e6682d7a8f64f" => :yosemite
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
      res.body = JSON.generate([resp])
    end

    Thread.new { server.start }

    begin
      ENV["EMPIRE_API_URL"] = "http://127.0.0.1:8035"
      assert_match /v1  zab  Oct 1(1|2|3)  2015  my awesome release/,
        shell_output("#{bin}/emp releases -a foo").strip
    ensure
      server.shutdown
    end
  end
end
