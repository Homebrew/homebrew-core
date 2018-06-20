class PilosaConsole < Formula
  desc "Web-based user interface for Pilosa"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/console/archive/v0.1.tar.gz"
  sha256 "cb79a282c5050ae0ed195597b0c5ee4467515d04061e3c9dd7086527ddbaee78"

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "go-statik" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/pilosa/console").install buildpath.children

    cd "src/github.com/pilosa/console" do
      system "make", "build", "FLAGS=-o #{bin}/pilosa-console", "VERSION=v#{version}"
      prefix.install_metafiles
    end
  end

  test do
    begin
      server = fork do
        exec "#{bin}/pilosa-console"
      end
      sleep 0.5
      assert_match("<!DOCTYPE html>", shell_output("curl localhost:8000"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
