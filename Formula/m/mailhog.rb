class Mailhog < Formula
  desc "Web and API based SMTP testing tool"
  homepage "https://github.com/mailhog/MailHog"
  url "https://github.com/mailhog/MailHog/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "6227b566f3f7acbfee0011643c46721e20389eba4c8c2d795c0d2f4d2905f282"
  license "MIT"
  head "https://github.com/mailhog/MailHog.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4c49d108311e4eb9021edf775bb06695e02dad66525853a7da265be2dfdfb9bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51e6965b16a8d1c9fa3be69f3f30dc922bac2b721c040b3891afe53178d5c2cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ced5d8a79864ec2e24dd10244c8f8c02ea877f5039cebbc52d67008878a90384"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b089cb4b0b631510bd8454442227cc126847626f414c3607bba679aa98f10a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2cd7cb1b3d603d1696ffe8f6ff7704e7cf5a46fce3989160f66bf552fd1d754"
    sha256 cellar: :any_skip_relocation, sonoma:         "fe103d8427c4a381eae006d4b8fe928cc2abcb1bde31f1ece0018eddb7932a41"
    sha256 cellar: :any_skip_relocation, ventura:        "6a45f9cc5d9d2de936cc8d045927ab623c87afbad9616ddf3e6e5b09c6f55dda"
    sha256 cellar: :any_skip_relocation, monterey:       "0e54558a9977b4e4106dd96395cb854253af643661089c0523cd26dbf77bca65"
    sha256 cellar: :any_skip_relocation, big_sur:        "427f2af18b97af3d6b99e5d311b663a52ef85f6c2b04a6952ba691247e65df3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b66c1a2cbd67663bd1046ec584e8a9fd8518b7b68a3907ded7b6225d55774da"
  end

  # No support for Go modules and needs deprecated `go_resource` DSL.
  # https://github.com/mailhog/MailHog/issues/442#issuecomment-1493415258
  deprecate! date: "2024-03-27", because: :unmaintained
  disable! date: "2025-03-31", because: :unmaintained

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    path = buildpath/"src/github.com/mailhog/MailHog"
    path.install buildpath.children

    system "go", "build", *std_go_args(output: bin/"MailHog", ldflags: "-s -w"), path
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
