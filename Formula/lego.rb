class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
      tag:      "v4.1.3",
      revision: "086040a8ba1c30336110130df2eafefba1428a6a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b99349308a1af2cc963b3c825cb0fefc37ea21b7ea98497c2e9e49f1c9329bd6" => :big_sur
    sha256 "20a37f8e5ccbd6f40908a2d60fd2c4f41aadfd5fc65b861174c181e908c60320" => :catalina
    sha256 "fc8c01b9e2e5cefcbf9f3f0d002c534d1a7c320b4e7a53849bdcd01fd4f5e4a2" => :mojave
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
