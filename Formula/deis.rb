class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.10.0.tar.gz"
  sha256 "de5a9b1dd8746059c77b63472ae8d9a788e3f3cccdb190f8f307e3fdbb309700"

  bottle do
    sha256 "274ce1639c8b85fff3fd4a315e260ac37baa5d66b52357d4d08b45cefa29cb15" => :sierra
    sha256 "2ac131bc5838ab6970cb6fb8269491c6eaa1ba4520c73ff4f0544d4b818c673b" => :el_capitan
    sha256 "a0b0c61cd39b47af6262a7fa13ad6b6d02118cc233b8bd78303172f3d0d02e83" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = `dirname #{buildpath}`.chomp
    ENV["GOBIN"] = ENV["GOPATH"] + "/bin"
    (buildpath/"src/github.com/deis").mkpath
    (buildpath/"bin").mkpath
    ln_s buildpath, "src/github.com/deis/workflow-cli"
    system "go", "get", "github.com/mitchellh/gox"
    system "go", "get"
    system "../bin/gox", "-verbose", "-ldflags",
      "'-X=github.com/deis/workflow-cli/version.Version=v2.10.0'",
      "-os=darwin", "-arch=amd64", "-output=#{bin}/deis"
  end

  test do
    system bin/"deis", "logout"
  end
end
