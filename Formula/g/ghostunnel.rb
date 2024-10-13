class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "7eee035a6e721d4d7ec43470ba684fd5c7fe1419bcdbf4b04e675547ea12fc52"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ca399cd1310d6dcb5609ac32a31d2f976c9767abfc49d20882a81feefc98d037"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7cf835b378f1e1f0e0f109a6afdd584435416569feee4a07661c2d70bd08b666"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "761ae383c547e4e55f055f7562dc0eba31f238ade220701e47b90391868fafbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b252f0100b7d619bec29a6ad5ab615c31a8c899b1b3275a1eb75bc55b7ea3dd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "1919980028be34742c7ecd6263340d64ea25d8973d96e70355274fba386a5f69"
    sha256 cellar: :any_skip_relocation, ventura:        "5f6a085780f03390972f4fa435a46ec4f4ec5c8935c2fa9200a76b9aa8263648"
    sha256 cellar: :any_skip_relocation, monterey:       "2ac1cb48fac689de39e535d133d8a8fd690fcb960a321bb112c475ed862e7290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdd744b410bf392812ecae56ebda39714e76632e81918d4aa138dfaf23815474"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    port = free_port
    fork do
      exec bin/"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
