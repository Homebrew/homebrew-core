class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.18.tar.gz"
  sha256 "8a4ebcb3ce8e3ed3649be870ab407fafeaeaed23c399f18dc25cba50fbb7f5a6"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aadf1887c4fb92be9b9ca0639f03670b056f4aea14b75db11197a4f29e5bf942" => :sierra
    sha256 "3b3a5451ba2cedf14adaaaa6928c300de9c88ff4ea7bb9e35bbd6c9090eb65a6" => :el_capitan
    sha256 "944e4effa6edbccb66649200782f6439295519390f2cbb47e476cfb4a1864c83" => :yosemite
    sha256 "300573098e20510b6593243628275c433f81f3cc8b08a74848e61b32ec6ef49a" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/keybase/client/").install "go"

    system "go", "build", "-a", "-tags", "production brew", "github.com/keybase/client/go/keybase"
    bin.install "keybase"
  end

  test do
    system "#{bin}/keybase", "-standalone", "id", "homebrew"
  end
end
