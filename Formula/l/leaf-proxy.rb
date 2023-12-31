class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  stable do
    url "https://github.com/eycorsican/leaf/archive/refs/tags/v0.10.7.tar.gz"
    sha256 "7086c66420f04c17552a11e65ae9d5db7297ac2e764da3efe0e528f7265875a2"

    # Backport fix for newer protobuf crate. Remove in the next release.
    patch do
      url "https://github.com/eycorsican/leaf/commit/b92e08ad4110a8460db1dc3c426be7f8651eccc0.patch?full_index=1"
      sha256 "25f0cbc02a6a49ba5b7b5319dceb2b3dfcd7c2e0547f57a0db9fce52f6b1b306"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9024594748d1e51a529a513957cd12f33a8e41f7fa6f9b473d7c4461886d650b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7808c1c2afc8362696badf46e8bc0a64b7db2b84b1d45638a1bbb272881d0b1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f36e347a648a2537c681970cc1f3518e97b9ba2caedb70d7b09c5ee6db4f25e"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ca65e362c68a17f59b184a028483ea748193661f1c3b1038ecff23e48a462b6"
    sha256 cellar: :any_skip_relocation, ventura:        "5bbf2afcfa76736ea8d715851c35d38f019ebe8709524fe53bb549f24dfb636b"
    sha256 cellar: :any_skip_relocation, monterey:       "98922b5b7eb9a1e9859cfb90b544f318082dbf94c494ea82d824dd499a4b74b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0689bb77d1cea3b31b81f312a37a06907d13d7a752ce36338886d47fd9229533"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  def install
    system "cargo", "install", *std_cargo_args(path: "leaf-bin")
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
