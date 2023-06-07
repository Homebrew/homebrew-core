require "language/go"

class Mailhog < Formula
  desc "Web and API based SMTP testing tool"
  homepage "https://github.com/mailhog/MailHog"
  license "MIT"
  head "https://github.com/mailhog/MailHog.git", branch: "master"

  stable do
    url "https://github.com/mailhog/MailHog/archive/v1.0.1.tar.gz"
    sha256 "6227b566f3f7acbfee0011643c46721e20389eba4c8c2d795c0d2f4d2905f282"

    go_resource "github.com/gorilla/context" do
      url "https://github.com/gorilla/context.git",
          revision: "08b5f424b9271eedf6f9f0ce86cb9396ed337a42"
    end

    go_resource "github.com/gorilla/mux" do
      url "https://github.com/gorilla/mux.git",
          revision: "599cba5e7b6137d46ddf58fb1765f5d928e69604"
    end

    go_resource "github.com/gorilla/pat" do
      url "https://github.com/gorilla/pat.git",
          revision: "cf955c3d1f2c27ee96f93e9738085c762ff5f49d"
    end

    go_resource "github.com/gorilla/websocket" do
      url "https://github.com/gorilla/websocket.git",
          revision: "a91eba7f97777409bc2c443f5534d41dd20c5720"
    end

    go_resource "github.com/ian-kent/envconf" do
      url "https://github.com/ian-kent/envconf.git",
          revision: "c19809918c02ab33dc8635d68c77649313185275"
    end

    go_resource "github.com/ian-kent/go-log" do
      url "https://github.com/ian-kent/go-log.git",
          revision: "5731446c36ab9f716106ce0731f484c50fdf1ad1"
    end

    go_resource "github.com/ian-kent/goose" do
      url "https://github.com/ian-kent/goose.git",
          revision: "c3541ea826ad9e0f8a4a8c15ca831e8b0adde58c"
    end

    go_resource "github.com/ian-kent/linkio" do
      url "https://github.com/ian-kent/linkio.git",
          revision: "77fb4b01842cb4b019137c0227df9a8f9779d0bd"
    end

    go_resource "github.com/mailhog/MailHog-Server" do
      url "https://github.com/mailhog/MailHog-Server.git",
          revision: "50f74a1aa2991b96313144d1ac718ce4d6739dfd"
    end

    go_resource "github.com/mailhog/MailHog-UI" do
      url "https://github.com/mailhog/MailHog-UI.git",
          revision: "24b31a47cc5b65d23576bb9884c941d2b88381f7"
    end

    go_resource "github.com/mailhog/data" do
      url "https://github.com/mailhog/data.git",
          revision: "024d554958b5bea5db220bfd84922a584d878ded"
    end

    go_resource "github.com/mailhog/http" do
      url "https://github.com/mailhog/http.git",
          revision: "2e653938bf190d0e2fbe4825ce74e5bc149a62f2"
    end

    go_resource "github.com/mailhog/mhsendmail" do
      url "https://github.com/mailhog/mhsendmail.git",
          revision: "9e70164f299c9e06af61402e636f5bbdf03e7dbb"
    end

    go_resource "github.com/mailhog/smtp" do
      url "https://github.com/mailhog/smtp.git",
          revision: "0c4e9b7e0625fec61d0c30d7b2f6c62852be6c54"
    end

    go_resource "github.com/mailhog/storage" do
      url "https://github.com/mailhog/storage.git",
          revision: "6d871fb23ecd873cb10cdfc3a8dec5f50d2af8fa"
    end

    go_resource "github.com/philhofer/fwd" do
      url "https://github.com/philhofer/fwd.git",
          revision: "98c11a7a6ec829d672b03833c3d69a7fae1ca972"
    end

    go_resource "github.com/t-k/fluent-logger-golang" do
      url "https://github.com/t-k/fluent-logger-golang.git",
          revision: "0f8ec08f2057a61574b6943e75045fffbeae894e"
    end

    go_resource "github.com/tinylib/msgp" do
      url "https://github.com/tinylib/msgp.git",
          revision: "362bfb3384d53ae4d5dd745983a4d70b6d23628c"
    end

    go_resource "golang.org/x/crypto" do
      url "https://go.googlesource.com/crypto.git",
          revision: "cbc3d0884eac986df6e78a039b8792e869bff863"
    end

    go_resource "gopkg.in/mgo.v2" do
      url "https://gopkg.in/mgo.v2.git",
          revision: "3f83fa5005286a7fe593b055f0d7771a7dce4655"
    end
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ced5d8a79864ec2e24dd10244c8f8c02ea877f5039cebbc52d67008878a90384"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b089cb4b0b631510bd8454442227cc126847626f414c3607bba679aa98f10a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2cd7cb1b3d603d1696ffe8f6ff7704e7cf5a46fce3989160f66bf552fd1d754"
    sha256 cellar: :any_skip_relocation, ventura:        "6a45f9cc5d9d2de936cc8d045927ab623c87afbad9616ddf3e6e5b09c6f55dda"
    sha256 cellar: :any_skip_relocation, monterey:       "0e54558a9977b4e4106dd96395cb854253af643661089c0523cd26dbf77bca65"
    sha256 cellar: :any_skip_relocation, big_sur:        "427f2af18b97af3d6b99e5d311b663a52ef85f6c2b04a6952ba691247e65df3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b66c1a2cbd67663bd1046ec584e8a9fd8518b7b68a3907ded7b6225d55774da"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    ENV["GO111MODULE"] = "auto"

    path = buildpath/"src/github.com/mailhog/MailHog"
    path.install buildpath.children

    # restore use of vendor directory for > 1.0.0
    Language::Go.stage_deps resources, buildpath/"src" if build.stable?

    cd path do
      system "go", "install", "-v", ".../MailHog"
      prefix.install_metafiles
    end
  end

  service do
    run [
      opt_bin/"MailHog",
      "-api-bind-addr",
      "127.0.0.1:8025",
      "-smtp-bind-addr",
      "127.0.0.1:1025",
      "-ui-bind-addr",
      "127.0.0.1:8025",
    ]
    keep_alive true
    log_path var/"log/mailhog.log"
    error_log_path var/"log/mailhog.log"
  end

  test do
    address = "127.0.0.1:#{free_port}"
    fork { exec "#{bin}/MailHog", "-ui-bind-addr", address }
    sleep 2

    output = shell_output("curl --silent #{address}")
    assert_match "<title>MailHog</title>", output
  end
end
