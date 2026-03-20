class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "605bfb0a12b187824a3958066e7e9651a6bfb2f0a889041e73e1d58bb706ed43"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce4ddbc5258b07aa7d6fc9b17843eb49d3cb45df5d0a5d341d0d30a5557161e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea5824292f3c9cd445bdbb5d510aa17f781116cdd00b50bd2aafb0df10846ad9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d45757c8417275f5a65eb781991564d9a737d39cab6c17675b01f6245113629c"
    sha256 cellar: :any_skip_relocation, sonoma:        "143381004f03317bd67bc74f5e8457218e6d6ea42d99ee7053994eb26f48b02b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1d489c122431f770ff38e13b235af6403a14a826808da7c113ee1f87013dc5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "441cf4911893e34463aef2e632ad6255d48128c750f0b6f7c66ed3d94b86383e"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "leaf-cli")
  end

  test do
    (testpath/"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS"

    assert_match "TCP failed: all attempts failed", output
  end
end
