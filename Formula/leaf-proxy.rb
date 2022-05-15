class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.6.0.tar.gz"
  sha256 "5b22932e1dea586ead051a09a4c416e538c29c85d1782718e4652415e59884e8"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6258fb1696dea42aa9675cc22017875fdd5428353a91dbe5a3106cd73b593e44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a59bc8806af6ec3a98f8dd50fa83c8b2c74be95da50e2c5c20d018e3e560d886"
    sha256 cellar: :any_skip_relocation, monterey:       "c8dd9595621a1a9de7f556b22346d57254a401b0357f39168ade28b97dc77cbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c19081c5636872dfedef7847d1b65bcf4e8c5c530193947efe5e903a863b5f25"
    sha256 cellar: :any_skip_relocation, catalina:       "dc381d204d5514ba8d20338804775ca9f9c6dded50e7c20ea4230791665329b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "550d6fa4195d739f1131e9a241ab4aa7272908bf8f66005606f2e990e283f9bf"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    cd "leaf-bin" do
      system "cargo", "install", *std_cargo_args
    end
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
