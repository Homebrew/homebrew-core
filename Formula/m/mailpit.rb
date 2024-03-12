require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.14.4.tar.gz"
  sha256 "c8eef5c6379ffc3e66211d055d7919589f9ee85bf74272c83d471bf1d4d12444"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "944e05a084773dc9be4b64d962cd12fef05ca43f5fb7d4182178cdca153c799a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba37f9a0522167530195d53c8d702992c7311691d1ad6d073ec5fdf0ed97476c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efe3f62c321b2118c97736c618a7892422dd8f6d8ca0cc2f4fcbf9817b50480c"
    sha256 cellar: :any_skip_relocation, sonoma:         "242cc177887ccecde4a050951fc7d3f32d7b64416e980691a9f27a74bc98a4d9"
    sha256 cellar: :any_skip_relocation, ventura:        "9a0a301d41caece65135143bfb09c1af4d7b0ff730a9a75231bd597e0586b856"
    sha256 cellar: :any_skip_relocation, monterey:       "06ce32893c0f446cb49dac66a548558e82648cf02601f3ce027ff10e828bc2cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f47eabd46f9d8558669a737f6a5ebf28330364df0c0dda81276f63d81f148b0"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
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
