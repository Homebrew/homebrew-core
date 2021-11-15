class Ghostunnel < Formula
  desc "Simple SSL/TLS proxy with mutual authentication"
  homepage "https://github.com/ghostunnel/ghostunnel"
  url "https://github.com/ghostunnel/ghostunnel/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "c86c04b927b45cbaa3dbb6339d9e89e00fe0f4235bb3c0a50c837f3f89a42df4"
  license "Apache-2.0"
  head "https://github.com/ghostunnel/ghostunnel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ea9fe350020419353724b00bab8df806958b690f793f35411163bc2ffbe1ad5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e29c9322e028759b02a968914b4739157d3db6abc6ba367e9a5c9f1995b282b0"
    sha256 cellar: :any_skip_relocation, monterey:       "e91c415434646d525d228aac3bcfdd6a247ee312fab44c8e1874067624c2cdad"
    sha256 cellar: :any_skip_relocation, big_sur:        "b93ac43836099084bb444f2572886e0925bbe3184160a219cc4ab667c8ca23f8"
    sha256 cellar: :any_skip_relocation, catalina:       "6e3a12df1cd0d68dc23bd0ebdb73d0fb30e92a8c4cfa56e3601302123a45a908"
    sha256 cellar: :any_skip_relocation, mojave:         "2b518ddd7d5cba3bf9dfb99980ae5f8fa8cc9ad5b1cd8be8e275408886d20290"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    port = free_port
    fork do
      exec bin/"ghostunnel", "client", "--listen=localhost:#{port}", "--target=localhost:4",
        "--disable-authentication", "--shutdown-timeout=1s", "--connect-timeout=1s"
    end
    sleep 1
    shell_output("curl -o /dev/null http://localhost:#{port}/", 56)
  end
end
