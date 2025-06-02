class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://mailpit.axllent.org/"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.25.1.tar.gz"
  sha256 "a07d67df485988ecea25b2db9cc91b31d64c3e6c655e61ceb3fb6473a5815723"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "171dc8924fb3eb676a12b2d2f3c4870957674ea9c054aa0fdcf36c2b0ba0fedc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3d300309092f081081b5081200d8b4a8775820f2b9a04df0f8b0510c65cd372"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "98ad491e0316259da7c5438718d8c9dbfd3ee21f8048134d741bfa1150d905be"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee0580ae8fd1d02b45d17d495e9816247d228f02d60001d1f27d1042e7c69d38"
    sha256 cellar: :any_skip_relocation, ventura:       "804f65100aa5cfeb4696ff83b2a201133cb400a524cd5a7fb4f882dc95f6a4e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "716ea130afe883b8d087dcbabe8f27ffb5a19a0ee263b89e0b19c49830598927"
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
