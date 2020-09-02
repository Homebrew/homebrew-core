class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    tag:      "v4.0.0",
    revision: "c65edde24586a331363b4b43d9baabfc4b7b8aed"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "07a313017b535766bc6be9911528c70acba3175d4fab125dec63b6442486cd3d" => :catalina
    sha256 "e0f7035f3948882f3ec7f94721baf408f93cb25e96728a166f83b87ef02c75ca" => :mojave
    sha256 "04f0d2bece9478bb406d27848555903069148c72a86f1185497e3a683ac79bb8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath",
        "-o", bin/"lego", "cmd/lego/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
