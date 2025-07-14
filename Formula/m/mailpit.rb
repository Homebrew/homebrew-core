class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.27.1.tar.gz"
  sha256 "fd9d2d6226b2ab0f92c1249c7469e8341f8bbb241f878c91e9f9d4d3edeecf4a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f7b374b29cda059b494b2fab5bcc340c7d0c077898ee23c37b3d4c0d93b39711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29ac70c1949a3aeaca504686e634b9ca36e9486601d3a561726657246e12dec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "65300d9f742221afa3f5f5f09cfb43dc03a1ee8d0e2055ca22742cb2c59e6690"
    sha256 cellar: :any_skip_relocation, sonoma:        "56b6c961d2b54a56da7f5599445a270e9ec6cd3419149e5dc918c24c2304127e"
    sha256 cellar: :any_skip_relocation, ventura:       "b10307e1ebda99c39d1e1089ed7419936b7bcce8cd459f556513e9a391ad9b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d571ae5b2735c9babe8d094d0ab1abca6abf5ce5d467c4951827b44a9af8d8b3"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", "completion")
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
