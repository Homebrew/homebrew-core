class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/refs/tags/v0.10.12.tar.gz"
  sha256 "5c351b19fcce9262f99ecde37a18b5eb36acb6105f922f096834e6a5bdcfb382"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4e79e7b4917b497e62e680fc60e650ed437f41761b9d1fb54ceecfb937cec5a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0e0ad0469bf055289335cfa72fcd7221048ce9a7f51d4e06fcca4031a62609f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "827f0f56426f5d9191cd74fb6749592056cbed54f1e2dfd0066f634c2a020ae3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0457b29d36b81c3d45a22b22cfd2227564f58d169e0009a0d6de75b9e09ca157"
    sha256 cellar: :any_skip_relocation, ventura:        "0f52e99247893a83f0bd1cda9c05c94a47a45905fc3492de78351b90caff189e"
    sha256 cellar: :any_skip_relocation, monterey:       "470db8da56590d269ae348f3480904770882f76f45ab2966dd7b28a9c63f2d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad86cc7b712d96dfb9660827bf345f5b7306218caddcaf314356cac0530132f4"
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
