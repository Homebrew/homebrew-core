class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.8.16.tar.gz"
  sha256 "1f1dc78f5305ec0e64dc003e471404cca1746d55bdb3ff63dc92e2dff55a90e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c7ec02814a736547ceb6d94a82812234f35fa1dda0658502143d8e386fc29d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58720601e340a259ac4b97162ab0a90bc6bd6bad311643505cfbdad5f13db3b1"
    sha256 cellar: :any_skip_relocation, monterey:       "5f57691ba7d8d6a544a0c79ee05390d9e3c81469f8f93b3fb2cde82b60fc2a83"
    sha256 cellar: :any_skip_relocation, big_sur:        "9619228b878fff1a5d76c839576932ed107b11b5451bb438c7d41f18ec97cc24"
    sha256 cellar: :any_skip_relocation, catalina:       "28bcc463613f643b4d74b16c2cb52924ec3e8db61cddcc7d09fbe6de81b1d2c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc32df5e5de65413ff919377d7efa67b03f39aa7695205307e9ee42163f13c6f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
