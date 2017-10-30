class Docker2aci < Formula
  desc "Library and CLI tool to convert Docker images to ACIs"
  homepage "https://github.com/appc/docker2aci"
  url "https://github.com/appc/docker2aci/archive/v0.17.1.tar.gz"
  sha256 "1cf70d12b20c15a0fea3bf3330f7ddf507ed3d94e5af40c4cce7ab8fdfaeaa72"

  bottle do
    cellar :any_skip_relocation
    sha256 "d290f70a22e626cbb77bae170833cc85722d8117caac9cd06b615d9fa7e7082c" => :high_sierra
    sha256 "592a831c0425d69dc6dcda04c326cc3cc6c92c198f6b04787877c0d784ee6e55" => :sierra
    sha256 "6dce9bc1299cafa3b9bdd090b33145421b2fe3dfed9bb9bfc4fad75363cfd1b2" => :el_capitan
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
