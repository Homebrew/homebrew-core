require "language/go"

class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps/archive/v0.5.0.tar.gz"
  sha256 "5f3fe0bb1a0ca75616ba2cb6cba7b11c535ac6c732e83c71f708dc074e489b1f"

  depends_on "go" => :build

  go_resource "github.com/jeffail/gabs" do
    url "https://github.com/jeffail/gabs.git",
      :revision => "ee1575a53249b51d636e62464ca43a13030afdb5"
  end

  go_resource "github.com/ajaxorg/ace-builds" do
    url "https://github.com/ajaxorg/ace-builds.git",
      :revision => "e3ccd2c654cf45ee41ffb09d0e7fa5b40cf91a8f"
  end

  go_resource "github.com/elazarl/go-bindata-assetfs" do
    url "https://github.com/elazarl/go-bindata-assetfs.git",
      :revision => "57eb5e1fc594ad4b0b1dbea7b286d299e0cb43c2"
  end

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
      :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  go_resource "github.com/garyburd/redigo" do
    url "https://github.com/garyburd/redigo.git",
      :revision => "8873b2f1995f59d4bcdd2b0dc9858e2cb9bf0c13"
  end

  go_resource "github.com/go-sql-driver/mysql" do
    url "https://github.com/go-sql-driver/mysql.git",
      :revision => "527bcd55aab2e53314f1a150922560174b493034"
  end

  go_resource "github.com/jeffail/util" do
    url "https://github.com/jeffail/util.git",
      :revision => "48ada8ff9fcae546b5986f066720daa9033ad523"
  end

  go_resource "github.com/lib/pq" do
    url "https://github.com/lib/pq.git",
      :revision => "3cd0097429be7d611bb644ef85b42bfb102ceea4"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
      :revision => "f9ab0dce87d815821e221626b772e3475a0d2749"
  end

  go_resource "github.com/amir/raidman" do
    url "https://github.com/amir/raidman.git",
      :revision => "91c20f3f475cab75bb40ad7951d9bbdde357ade7"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
      :revision => "bf531ff1a004f24ee53329dfd5ce0b41bfdc17df"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "db8e4de5b2d6653f66aea53094624468caad15d2"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/jeffail/"
    ln_sf buildpath, buildpath/"src/github.com/jeffail/leaps"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/leaps", "./cmd/leaps"
  end

  test do
    begin
      port = ":8080"

      # Start the server in a fork
      leaps_pid = fork do
        exec "#{bin}/leaps", "-address", port
      end

      # Give the server some time to start serving
      sleep(1)

      # Check that the server is responding correctly
      assert_match /Choose a document from the left to get started/, shell_output("curl -o- http://localhost#{port}")
    ensure
      # Stop the server gracefully
      Process.kill("HUP", leaps_pid)
    end
  end
end
