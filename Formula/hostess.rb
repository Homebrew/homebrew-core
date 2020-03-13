class Hostess < Formula
  desc "Idempotent command-line utility for managing your /etc/hosts file"
  homepage "https://github.com/cbednarski/hostess"
  url "https://github.com/cbednarski/hostess/archive/v0.5.2.tar.gz"
  sha256 "ece52d72e9e886e5cc877379b94c7d8fe6ba5e22ab823ef41b66015e5326da87"
  head "https://github.com/cbednarski/hostess.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f81fb164e79a68747d694a9f44788086e27ba646e0e05d12bcbfb57bf4733c5d" => :catalina
    sha256 "4c6b07faed95a772ce07e4e0634d784abc223433e3a49c31740d238e8052e900" => :mojave
    sha256 "ad68ebfe0c89d97c1790b8c10b2cbc9fbda50ec5e96bef0da5c499d82cc7a5b0" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-o", bin/"hostess"
  end

  test do
    assert_match "localhost", shell_output("#{bin}/hostess ls 2>&1")
  end
end
