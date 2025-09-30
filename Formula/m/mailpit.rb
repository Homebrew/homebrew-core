class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.27.9.tar.gz"
  sha256 "273bb0ed1f7ac3976c48d6e430c61740527799c036f37e1a6c698b1d7ac17c17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2683aefab04066f5de46f0e5460fdc47a7fa0331748aa93807d493e13d3b50e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2735f66144e25f2d3fb7310f94a9d677acb35fb2868757a6456abc56f9fe991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76096578d8e819b94406d954d35a159fb800f1c8d497c5fb4aba4641ff678302"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff0b47e9ba9107de0f8b13aa22aeef04e3ff283082446f62e06d226ce186c29b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ff00ecdcf9c693188effddf1af561a5609293a172a9a9b1c3b298ba375f786c"
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
