class Hyper < Formula
  desc "Client for the Hyper_ cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
    :tag => "v1.10.2",
    :revision => "302a6b530148f6a777cd6b8772f706ab5e3da46b"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0650959c86934476fa4749a852e5e17fb4d5b3299e7ed5f666b45551dcd9367" => :sierra
    sha256 "376bc7d36f99af675639c7805702c8b39104de5016f93298e1af4066de21eea1" => :el_capitan
    sha256 "853b5eb62fcab76298f6ae71b04e222f8e9807f95466920f3a1453ae62163c5c" => :yosemite
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
