class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-4.9.tar.gz"
  sha256 "445e1dfcca4cc14587e083704389fb0bc4de8189597740a35ef3b7acdf56036b"
  license "Apache-2.0"

  livecheck do
    url "https://linuxcontainers.org/lxd/downloads/"
    regex(/href=.*?lxd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d68bfcf7ddb0fdd312c48ce45ef7fadb8737f9833915fc1efa481f880a054319" => :big_sur
    sha256 "01db96a44e283ac88acc477f7d6e273da038407036bbea7d0fe7eb73a8ffc0c3" => :catalina
    sha256 "6f836ee1ad36d07b200c788fc389642fcb5129697e4a461e7c0fd40429fba50f" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    ENV["GO111MODULE"] = "auto"

    ln_s buildpath/"_dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
