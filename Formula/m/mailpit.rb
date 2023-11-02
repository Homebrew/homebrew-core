require "language/node"

class Mailpit < Formula
  desc "Web and API based SMTP testing"
  homepage "https://github.com/axllent/mailpit"
  url "https://github.com/axllent/mailpit/archive/refs/tags/v1.9.10.tar.gz"
  sha256 "71b3b12f585cfb8fbda4a2d401d646ce65d406dce3a3ffaaccb69c6ca404393b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5f5da0e3bc3113e2fe73e15c5dfa227e469523c1190ab7e72404e4d40140ab2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6379e551ccc00e777ba577c22bfc4ff74df91d22406ff47590d587f43b998bef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e399202c1bf587f5a0d4215eabc73fc7e9e42e25778efd712822477d3b7f9d50"
    sha256 cellar: :any_skip_relocation, sonoma:         "be27df50772852bd8f3285e9dd9d60318264df2afeeb56ee0ebeecb2c42a4b11"
    sha256 cellar: :any_skip_relocation, ventura:        "c030033d3320956959e6c7bb36e9cca120bfcb75f04718190a15c5bd74a2446a"
    sha256 cellar: :any_skip_relocation, monterey:       "d3c452b5f9cb02d6cec2e77d34a0285dd9066c72d293775e9a4c9e667acc22a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec6aafe220164d8ed3ae07920e30c7b49dc08d8c08e3a9747bf008b1dac187b1"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    system "npm", "install", *Language::Node.local_npm_install_args
    system "npm", "run", "build"
    ldflags = "-s -w -X github.com/axllent/mailpit/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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

    assert_match version.to_s, shell_output("#{bin}/mailpit version")
  end
end
