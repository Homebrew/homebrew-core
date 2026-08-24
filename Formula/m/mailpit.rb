class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "010629f1c47c5a7e05818d1a2e2661ced9a16840355f328a68b7f780a4e50d8c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8e4d0fe1277e8505d8b31d215744e4febfcd88ed6cf6dc08e852b1911fac238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a00538a961dc3ebe03faed42636c43e96367d1e0607400c1a02b325eb1cf5c6b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "235da0a61f9df2207a891047bd6c71fea28035aa9a4c2dab225cca23dd512a09"
    sha256 cellar: :any_skip_relocation, sonoma:        "de6896da24f62eed2aa13d47e5374d30f635a07692504641ca5d96702945fc9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b867f7fe9e6d97ae4461a104700105dc87573cbcf8bca4c5b3b55526ee518a4"
    sha256 cellar: :any,                 x86_64_linux:  "179ef1e6020c2132abb9223403b10a946582ecb8d96423c86610a21b30bade5f"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *std_npm_args(prefix: false)
    system "npm", "run", "build"

    ldflags = "-X github.com/axllent/mailpit/config.Version=v#{version}"
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
