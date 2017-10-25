class Docker2aci < Formula
  desc "Library and CLI tool to convert Docker images to ACIs"
  homepage "https://github.com/appc/docker2aci"
  url "https://github.com/appc/docker2aci/archive/v0.17.1.tar.gz"
  sha256 "1cf70d12b20c15a0fea3bf3330f7ddf507ed3d94e5af40c4cce7ab8fdfaeaa72"

  bottle do
    cellar :any_skip_relocation
    sha256 "b94b0ec18771d421766c91da8b94e9695293120e1233e344f82a09e427da0552" => :high_sierra
    sha256 "1450bc41df34664d2258d919f9dbcf87d00e7657e228761a1197b6bbcb492e8f" => :sierra
    sha256 "90c8ade536b1f6b907e48dc6cffd0b2f2035f4b2c515ca2a005becfdf180329d" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/appc").mkpath
    ln_s buildpath, buildpath/"src/github.com/appc/docker2aci"
    system "go", "build", "-o", bin/"docker2aci", "-ldflags",
      "-X github.com/appc/docker2aci/lib.Version=#{version}",
      "github.com/appc/docker2aci"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker2aci -version")
    system "#{bin}/docker2aci", "docker://busybox"
  end
end
