require "language/go"

class DockerSlim < Formula
  desc "DockerSlim (docker-slim): Optimize and secure your Docker containers (free and open source)"
  homepage "https://github.com/docker-slim/docker-slim"
  url "https://github.com/docker-slim/docker-slim.git",
    :tag => "1.18",
    :revision => "8c2da78b4560905e7e6bd101b8d2d5ffc640233c"
  head "https://github.com/docker-slim/docker-slim.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/docker-slim"
    ln_sf buildpath, buildpath/"src/github.com/docker-slim/docker-slim"

    ENV.prepend_create_path "PATH", buildpath/"bin"

    cd "src/github.com/docker-slim/docker-slim" do
      system "go", "build", "-v", "./cmd/docker-slim"
    end

    bin.install "bin/docker-slim"
  end

  test do
    usage = <<EOUSAGE
NAME:
   docker-slim - optimize and secure your Docker containers!

USAGE:
   docker-slim [global options] command [command options] [arguments...]

VERSION:
   1.18

COMMANDS:
     info, i     Collects fat image information and reverse engineers its Dockerfile
     build, b    Collects fat image information and builds a slim image from it
     profile, p  Collects fat image information and generates a fat container report
     help, h     Shows a list of commands or help for one command

GLOBAL OPTIONS:
   --debug                enable debug logs
   --log value            log file to store logs
   --log-format value     set the format used by logs ('text' (default), or 'json') (default: "text")
   --tls                  use TLS
   --tls-verify           verify TLS
   --tls-cert-path value  path to TLS cert files
   --host value           Docker host address
   --help, -h             show help
   --version, -v          print the version
EOUSAGE
    assert_match usage, shell_output("#{bin}/docker-slim --help")
  end
end
