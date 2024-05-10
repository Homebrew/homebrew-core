class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/refs/tags/v0.10.13.tar.gz"
  sha256 "b78d339930bdea24a38f88cf6c13eec7b54574f4a889bca5c426e7d5749b96f0"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd0fb626c6790a865408bb0728b0b040d536ce98265c2a5c167cbf25ce95f7ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25cb968974e7a8341e3ccbb41c82b99c3266c7318ccc5a9cb5488fb5179555c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "721a6cc289bba1ecbd777d68482b98fb35f0d462555689a17c4baca660cad8b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "208464888c66137036b928b814526006a383a934777ae59f364efe4b6bda97e8"
    sha256 cellar: :any_skip_relocation, ventura:        "9e44fbd75f88ef2936fc8d507e99f22b7e66ffa7909295c1ef692c58ce4d18fb"
    sha256 cellar: :any_skip_relocation, monterey:       "4c73786268db2687dbfc9f7e23aeb71df1ea9a6ae9245e36e8e6d98343362855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f64b59aa6ce768b1ff9fd5ce42991f0a52eff73d970b9ed684cb5014ae7e0f97"
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
