class Docker2aci < Formula
  desc "Library and CLI tool to convert Docker images to ACIs"
  homepage "https://github.com/appc/docker2aci"
  url "https://github.com/appc/docker2aci/archive/v0.17.2.tar.gz"
  sha256 "43cb18a3647ca8bae48a283fa3359e9555ab7a366c7ee9ef8a561797cebe2593"

  bottle do
    cellar :any_skip_relocation
    sha256 "38c55da3d7dae54ac615b1ef70d3b793ace880a3df8324c94586cbdcb0069a47" => :mojave
    sha256 "786e30d746607eea372c8eaa2705f850320dd74e28385fd3b75946e6e8c8e52d" => :high_sierra
    sha256 "6cfeb751ff7db4e703938e2bfc4e28d4ec9a30e59261e75aa5adf690d0f33061" => :sierra
    sha256 "b1a61fc4d329ef1e3ad97ea701e2c0be392f29e8d4a8bd2f1934bf7bac620121" => :el_capitan
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
