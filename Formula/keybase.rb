class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.18.tar.gz"
  sha256 "8a4ebcb3ce8e3ed3649be870ab407fafeaeaed23c399f18dc25cba50fbb7f5a6"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3d686ab1029e7a446f034f48822dd14583603e409087f52b756fe5665bc9493" => :sierra
    sha256 "24b1d12e70362b3601ba6ffa67a0ef487b2b8e0fe7aeca2cbfed1e7af47be168" => :el_capitan
    sha256 "5c969b19d2585ee5766d1f85ef6ff935086e2468d253091bf109ca8310906610" => :yosemite
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
