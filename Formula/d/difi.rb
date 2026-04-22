class Difi < Formula
  desc "Pixel-perfect terminal diff viewer"
  homepage "https://github.com/oug-t/difi"
  url "https://github.com/oug-t/difi/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "01117155dc86aef6ece17d8e6df40cc7c2c9a93cf0b5c8347167e9159f7d086c"
  license "MIT"
  head "https://github.com/oug-t/difi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "526c76c2dd6d2cfff9b9486a0eaa30a8d23549dd6ad24de56869ce0c50f416ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526c76c2dd6d2cfff9b9486a0eaa30a8d23549dd6ad24de56869ce0c50f416ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "526c76c2dd6d2cfff9b9486a0eaa30a8d23549dd6ad24de56869ce0c50f416ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "45e470bbbd3fbcbac2a26ffe4b25cd10c7f732e89ec17e6a2bf2a569b596df33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d7221fba5c001426c36db015ed615aa01612bd18be935c9717fd084f68c80e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9f52b83e77c046d18d700b8e531b34301bfd173c2ce3ef0d2b6ddc14dee3687"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/difi"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/difi -version")

    system "git", "init"
    system "git", "config", "user.email", "test@example.com"
    system "git", "config", "user.name", "Test"

    (testpath/"file.txt").write("one")
    system "git", "add", "file.txt"
    system "git", "commit", "-m", "init"

    File.write(testpath/"file.txt", "two")
    system "git", "commit", "-am", "change"

    output = shell_output("#{bin}/difi --plain HEAD~1")
    assert_match "file.txt", output
  end
end
