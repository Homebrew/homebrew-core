class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v4.2.0.tar.gz"
  sha256 "d43068499b259dd5c75137d443b2bafe36a72415355f859ba01bb4c0b9a51f9b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b99349308a1af2cc963b3c825cb0fefc37ea21b7ea98497c2e9e49f1c9329bd6" => :big_sur
    sha256 "f5023447b0ac0ae205c301e961b2199a748fdd5a8b78381822b4b54e3a2925a5" => :arm64_big_sur
    sha256 "20a37f8e5ccbd6f40908a2d60fd2c4f41aadfd5fc65b861174c181e908c60320" => :catalina
    sha256 "fc8c01b9e2e5cefcbf9f3f0d002c534d1a7c320b4e7a53849bdcd01fd4f5e4a2" => :mojave
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
