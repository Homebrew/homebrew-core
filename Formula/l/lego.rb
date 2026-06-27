class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/refs/tags/v5.2.2.tar.gz"
  sha256 "8d8d51415e39a4d5377b6a8448b915d820f67caa148aa828d0f682744f872cc6"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "44174c6a2b27d6447b6c3d72adacadb87120294d59424e6961e8e9bc8d8bbf0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44174c6a2b27d6447b6c3d72adacadb87120294d59424e6961e8e9bc8d8bbf0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44174c6a2b27d6447b6c3d72adacadb87120294d59424e6961e8e9bc8d8bbf0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae931eaea34d7a50af2b22bf5c5c9aab7aba4d2dbb27850d60322a607e49987a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45e7f8628d8b8acc3c4aa0bdcc0179adf383ee555a03d0c465d36c9f252d7ff2"
    sha256 cellar: :any,                 x86_64_linux:  "4b355896afebf3764cac701616375d41de3c38bc3a314197e3c113d42162e11d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1
    )
    assert_match "No account exists with the provided key", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
