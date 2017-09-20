class Hyper < Formula
  desc "Client for HyperHQ's cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
      :tag => "v1.10.15",
      :revision => "c9c8ca50eee61ba47a9eb3d195ae0d87566a4bd2"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e4a94135a6be5073c8c345e5b8be8b2126fd35c6642b497d4d20baca9f233a29" => :sierra
    sha256 "d6a19110403186baebda33d434abb6046f65ab70ff611e3e65adfe1fcac2f0a8" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/hyperhq"
    ln_s buildpath, "src/github.com/hyperhq/hypercli"
    system "./build.sh"
    bin.install "hyper/hyper"
  end

  test do
    system "#{bin}/hyper", "--help"
  end
end
