class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "http://deis.io"
  url "https://github.com/deis/deis/archive/v1.13.3.tar.gz"
  sha256 "a5b28a7b94e430c4dc3cf3f39459b7c99fc0b80569e14e3defa2194d046316fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "90c269eb5b26a5624dd123e45cb7ba204dd714ea03963047956dbc2464d74423" => :el_capitan
    sha256 "50747120100fc68b0361a91918a33e90afe032275e5f7185633ce3ad6902fb80" => :yosemite
    sha256 "100c0a9d3b26e49477c78e38f8bec0a5f921cd74f4fbc6410fec0d5039b37d20" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/deis").mkpath
    ln_s buildpath, "src/github.com/deis/deis"
    system "godep", "restore"
    system "go", "build", "-o", bin/"deis", "client/deis.go"
  end

  test do
    system bin/"deis", "logout"
  end
end
