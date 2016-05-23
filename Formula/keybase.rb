class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.16.tar.gz"
  sha256 "e8a7ecb56153c1068432ee7d13b861987066217eaa8d5346cc518468b618a112"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "265f030af32a124b0e4ebec4029ad05c08538fe02adc5865b2e2810bb0f2d9f1" => :el_capitan
    sha256 "cd5b687f19111f07427d4d1e82476fb3021e12bb872893b8dc1d29f03fae621b" => :yosemite
    sha256 "bbf3e0bb39c69cb54036d2862efd03e61c83cbca62084f833577a28a497a9b7d" => :mavericks
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
