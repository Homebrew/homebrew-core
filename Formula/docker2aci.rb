class Docker2aci < Formula
  desc "Library and CLI tool to convert Docker images to ACIs"
  homepage "https://github.com/appc/docker2aci"
  url "https://github.com/appc/docker2aci/archive/v0.17.0.tar.gz"
  sha256 "31c0c59f9b98d7ae5e643f060d914ef1e27dc8e2c17708593d24a4af7d9fcc01"

  bottle do
    cellar :any_skip_relocation
    sha256 "912c1d916c2e0414592cedfcdea040b7aeb8017ee9febcf6b109c7cdce61e508" => :high_sierra
    sha256 "07aa14d46698ae7cd5aaef1048dbc1e802361846bdae134c2ed08796d01e6f75" => :sierra
    sha256 "5487ddd0cb050bca91e6663ee430ddf08ec7995b4c4c31d9a39b91fb99f3217c" => :el_capitan
    sha256 "aef97426abd25cb8b8c0e20ba2285b8c63c31fb98a34a1af55c36bd9749185ad" => :yosemite
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
