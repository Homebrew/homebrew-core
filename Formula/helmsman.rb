class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
    tag:      "v3.4.4",
    revision: "9568064b9f1e0bbcb208f1083355861a63da86ba"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "124144b8d17651350350433fe6e65dcb6025146b27919c171fd6d4c6d37a7cf7" => :catalina
    sha256 "6b279f354d6c1b1ba6d9340750fca9b7809823354f892f4f941a8fcbd3f10d82" => :mojave
    sha256 "a7a21e2b4f07b283c989f0ce373ecbfe805788025656bdcfbbe3d74f9114419d" => :high_sierra
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
