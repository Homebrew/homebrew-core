class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    tag:      "v3.8.0",
    revision: "bcb5be49c87bab63f9bab23823fd79c7f3d4390a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "17099d47c1ca1215737ad2a61cfe812f1c3051dfb27f6741c2600d9f94a2a35b" => :catalina
    sha256 "c6aec7bc9b37aecf4fd683134ec2e8229d9ab26a4a0a8077cb4190c8c3c5507f" => :mojave
    sha256 "4e4f09df739135f9b06b618923d125bfa44d634c38f0170ce7a7bac1e126f801" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath",
        "-o", bin/"lego", "cmd/lego/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
