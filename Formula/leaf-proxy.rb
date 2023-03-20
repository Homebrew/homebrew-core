class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.7.2.tar.gz"
  sha256 "91cd8f97465924390c07da1bef42b387bc960fbb4eb7a86810720a0464dddf01"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25bf6c34b84870500c99f4890435f9ea0f26e8b3769eaa338a2dd6ae73f16aa2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f31d466c2605d8c8b1ec74c80835f6178870fa553d9abcf0326a43d4657f9ecb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa09c6d77159da1f364a78aa8c7cb9710f749d4c9ca9578fd1423e6ee0b012b1"
    sha256 cellar: :any_skip_relocation, ventura:        "9a519f25ff5a00fb190a6907bc593bb19b5a10087f4f6597ea2e053de8dec260"
    sha256 cellar: :any_skip_relocation, monterey:       "af914e475df5137a18e95f09496f9bf8952dec32c42b8aec646c36fc753e2f8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff195499a93bb9f041d437e5ff0e63889b4b5ef1ded909aac075c99e3ee0fcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cba7c4a85383c5a3126868f1865998e33b38aea8f4706c30f68cb235407a329"
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
