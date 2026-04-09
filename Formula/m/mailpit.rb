class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.29.6.tar.gz"
  sha256 "fa8bfc5a70ee20212f3bbfa1333d4a7b99f8e706f26d83a73143c4db1f0a45fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b36ead8b415440507a029be3c3172c7a03c30c1dfdb81f1a715d7689f5b5e2b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1edd29d973c949bef116b5c2373aecdf73058164f4db945e38870c0ee3d7185a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7387a68cd405c948d63be0f38caa3aeadc3361aebfdd4b0be170661ccbf65130"
    sha256 cellar: :any_skip_relocation, sonoma:        "25c117dbf85dd098b16323e782013f8c260835d99dfbf54f1bfa0cf3a3c11d41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee7f242d053ee0ab12b90fdd925359b444336a6bf7f7f46e9054ec7e1c736c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58a640cfc8b764a1cb244d537f356a7f5c7947509dfc5b8b6dcfd8078a0864d3"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"mailpit", shell_parameter_format: :cobra)
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
