class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "https://deis.io/"
  url "https://github.com/deis/workflow-cli/archive/v2.10.0.tar.gz"
  sha256 "de5a9b1dd8746059c77b63472ae8d9a788e3f3cccdb190f8f307e3fdbb309700"

  bottle do
    cellar :any_skip_relocation
    sha256 "a89e64ba9322120a17504308bd226e6cc9e9fc5c320f90d48908dc1c0a2f1915" => :sierra
    sha256 "968c126fa500f22fca2bf8ee9c015e15c645c278ca212063a85a587acd0e834b" => :el_capitan
    sha256 "6f5f2f84293444f497aed5c3b9bb8efb9c71ba65d06de2708d9cced75ad3447e" => :yosemite
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
