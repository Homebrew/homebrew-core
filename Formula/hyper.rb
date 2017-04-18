class Hyper < Formula
  desc "Client for the Hyper_ cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
    :tag => "v1.10.9",
    :revision => "1ed5d3fd838860558b757336b578fcb9bfb22499"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "11144e075470152acb855461e77ace302cd225844c5898e906b1a23c68cc251f" => :sierra
    sha256 "418e6d199cfce7a412a310bfb9b5f6f8c195d4b6a66f29a982f32fc0d0c8221b" => :el_capitan
    sha256 "75630cea940a7e7c37a26d2e1151b9fe4306ff7e8f3e24aecf92345df8910af4" => :yosemite
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
