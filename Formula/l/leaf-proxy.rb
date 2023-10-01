class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.10.3.tar.gz"
  sha256 "ccdec9fe7a24e43f5bf8fa8093aceeeec61e8f011e5dc28e27914b5c715114ee"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49448ef14df0719dcd594743b0fb5598fe3f2357eaf916563c95a5ceb78deb2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78cdb3a9057ee1bfd36dfcf6d7b0bfa0b09a16c92159688b92b7ea647be85865"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a56f060d1474577f56afb1f3ffb4435541d40a2bac04a75aa2d538f81e92a279"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab4cc1984c88355786a2c1386064ee91c682224ffc252ce1cab5dd92394f7858"
    sha256 cellar: :any_skip_relocation, ventura:        "d5c74436561078e16475585fdd69b54f8798224a0f3e9ed4dbf0b208a7830ff5"
    sha256 cellar: :any_skip_relocation, monterey:       "53841e5755bedd473b99df47a42feb43ff9de2bb65648da41ec32912c63201dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f55594463d92a17f643a663566b2629ae03c91ebdca1b173d3d44647b2a2164a"
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
