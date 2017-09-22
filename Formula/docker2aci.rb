class Docker2aci < Formula
  desc "Library and CLI tool to convert Docker images to ACIs"
  homepage "https://github.com/appc/docker2aci"
  url "https://github.com/appc/docker2aci/archive/v0.17.0.tar.gz"
  sha256 "31c0c59f9b98d7ae5e643f060d914ef1e27dc8e2c17708593d24a4af7d9fcc01"

  bottle do
    cellar :any_skip_relocation
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
