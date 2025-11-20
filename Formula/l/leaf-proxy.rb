class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "1754b3c1e38b1cf763919bda20894d3153d7835649b31f667715b5b8b4de512f"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "677a2da07190a4785329d5a5e55c490acaa0d27424dcc17db820a0cc94a7360b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60fbb58d1b20b0d93888eb142b59f5ace3eac671f13d4e9e505ab34f3b7ed30a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62b9454fe7c516c217f884c22ead935a04329cc9f2017e5aef5916a0e91d64a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5151af193b013aaa173c8c6bbee433b616f5deaa3a9d7e9225e5a884c162292f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "203f39457cf1ff8e6e6ead68cdf17843d33404a052d0eb33331f227ea4201aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a00fc0156b68f201cdd79e1d079f4fa6f93302b78d4785ec691852aa2d86d9c5"
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
