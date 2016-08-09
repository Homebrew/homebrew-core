class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.17.tar.gz"
  sha256 "937b4bc61c889ef3982a5352d8a49cda8a4f4db28732d4cb21df1fe20128399c"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a93ab21951e4cbd22ad4324613f21f74a46796f817474179b58498f0ffcffab4" => :el_capitan
    sha256 "496dd3b478bd0dad8942aa064fc231f1758e31529684740b5daf964cd9fca0ea" => :yosemite
    sha256 "9c68f69ce32d044e56d6e36606e27ea11301d2610822e8d8c5408b4179f226d1" => :mavericks
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
