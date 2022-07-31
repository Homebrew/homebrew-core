class Docker2aci < Formula
  desc "Library and CLI tool to convert Docker images to ACIs"
  homepage "https://github.com/appc/docker2aci"
  url "https://github.com/appc/docker2aci/archive/v0.17.2.tar.gz"
  sha256 "43cb18a3647ca8bae48a283fa3359e9555ab7a366c7ee9ef8a561797cebe2593"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "88e274de48f853b78bf647cf5860f74cb99ef4ca3a99c9cbb8500318e20952bc"
    sha256 cellar: :any_skip_relocation, mojave:      "38c55da3d7dae54ac615b1ef70d3b793ace880a3df8324c94586cbdcb0069a47"
    sha256 cellar: :any_skip_relocation, high_sierra: "786e30d746607eea372c8eaa2705f850320dd74e28385fd3b75946e6e8c8e52d"
    sha256 cellar: :any_skip_relocation, sierra:      "6cfeb751ff7db4e703938e2bfc4e28d4ec9a30e59261e75aa5adf690d0f33061"
    sha256 cellar: :any_skip_relocation, el_capitan:  "b1a61fc4d329ef1e3ad97ea701e2c0be392f29e8d4a8bd2f1934bf7bac620121"
  end

  # See https://github.com/rkt/rkt/issues/4024
  disable! date: "2022-07-31", because: :repo_archived

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
