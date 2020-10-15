class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    tag:      "v3.4.6",
    revision: "e43f983f52c4d4dad07b56439a8a29dbed35889b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "711bbb7d5b362cecd257a1c46dc73257ff7e5f9ba9b3e0c190874c73d8dcd423" => :catalina
    sha256 "2c044815fd6196791a4b46d30a469abc41b063e572393c83c2dc992a1e7754eb" => :mojave
    sha256 "9da4d396d0a14ae5288441de8c033d4aceb3c0d7fedde0dfa42404a90c9b6d84" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      "-trimpath", "-o", bin/"helmsman", "cmd/helmsman/main.go"
    prefix.install_metafiles
    pkgshare.install "examples/example.yaml"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/helmsman version")

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff plugin is not installed", output
  end
end
