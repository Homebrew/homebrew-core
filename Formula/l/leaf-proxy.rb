class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "f80d110ac56a0ffcdbcdcd1cc3631b6bf079ea18191d9a1c9f819cfff5b0c2fa"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b0cc5c4e172c32e79c24a0b7659d73e9bf8e7b64f67620da095a3c32abe345e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c32be304499e78ae7fb2a2b19a0fe5b4a61c8fd647c6dfd6972e58bd475cdfe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc98199bee56bf76f3948fea9b29c18e643bc106fae7bfa1358162490d4c3ec1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ddf82b5e08cf21b37d7df581fba6f0353fbfd97d3f6538c5a98de00571903ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f377ef7e09d7475844392754783e9a391154834c112fd7603960122108f61ab"
    sha256 cellar: :any_skip_relocation, ventura:        "7229899b4c36d25c75621c24a05581147c2870bd67425e5dbd34f9a47b08ae00"
    sha256 cellar: :any_skip_relocation, monterey:       "82a9e3aa050d2c96b66390624ec83cffe0c53602508cf9a4b8e24f7e285ba344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d39f8f3b4e0717ea0cfda518612b34cb02000441844685d689506cc9e453e4a9"
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
