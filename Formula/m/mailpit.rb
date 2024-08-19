class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.20.2.tar.gz"
  sha256 "147569854fea568d530594721f008de6df1cf19a4c6a7984a5ace56dbb75eab9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c27bf26467e4605ddfccc23f49504b59b034afcb8797b2e213586eae41d0180b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88914ee3db3ea3aed71afedba834e4969eb63871a57a6ba9d8717c14df2b590a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2884ec1d60b6f3343570d2702c5469f38818e401bbe58c5fb092a2de7bdda4f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2a67464fbe717cd2d1392c63c570c82b0e7ee1e46bc423a7c81c5ae0e94f1d9"
    sha256 cellar: :any_skip_relocation, ventura:        "1142721fb37987ad0aa371a0963d76ee8e02f1e45a7194aeb255c4d97fb91fba"
    sha256 cellar: :any_skip_relocation, monterey:       "cd6a4b2af0adc73b398effed65c8c60db3e7c7f8800a8a99b84f164a0236fc20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "77cfb4a17357e42e4302aac7df82ad132aef2b8d16ae483c155b514f0d64fdf4"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"
    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run opt_bin/"mailpit"
    keep_alive true
    log_path var/"log/mailpit.log"
    error_log_path var/"log/mailpit.log"
  end

  test do
    (testpath/"test_email.txt").write "wrong format message"

    output = shell_output("#{bin}/mailpit sendmail < #{testpath}/test_email.txt 2>&1", 11)
    assert_match "error parsing message body: malformed header line", output

    assert_match "mailpit v#{version}", shell_output("#{bin}/mailpit version")
  end
end
