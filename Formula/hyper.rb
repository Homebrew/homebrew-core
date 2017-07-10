class Hyper < Formula
  desc "Client for HyperHQ's cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
      :tag => "v1.10.13",
      :revision => "5c432742f0f5ba2eda9186576f11e2a93e8ea91e"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f1c422ba1380489ad7dbfe89fead091f2cf74bbc98089dac8cdf2b99fec9c40" => :sierra
    sha256 "d0ae31119f783928c51e7dc6a39543c30dbb7a4b76462bf2546f2d45dc4c2d79" => :el_capitan
    sha256 "2d80f8e5afbc5d66dad0b4aa650c48e944eac6ab8020763ec03b058c0bf0ab9e" => :yosemite
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
