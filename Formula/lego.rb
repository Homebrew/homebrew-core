class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.2.0.tar.gz"
  sha256 "d43068499b259dd5c75137d443b2bafe36a72415355f859ba01bb4c0b9a51f9b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b595da7dbfd1049bbc84d7b48fb9429bc3d66063cb46d5e07f655d9085168556" => :big_sur
    sha256 "7cb8bbe7c240db16f61187ba7faebb75686fa1393a343cad7e467e848cf2ff6e" => :arm64_big_sur
    sha256 "028e00c786018b4ce27c40d770fce87d2243063c23460f6a5fd16a618f0c6c25" => :catalina
    sha256 "f45b5a1e25b3f83fc91679ecdbd38148d46eb8cb94cdd40eb8791959f8999d43" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version}", "./cmd/lego"
  end

  test do
    output = shell_output("lego -a --email test@brew.sh --dns digitalocean -d brew.test run", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output("DO_AUTH_TOKEN=xx lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
