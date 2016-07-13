class Hyper < Formula
  desc "Client for the Hyper_ cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
    :tag => "v1.10",
    :revision => "603e437099a0dc94943ee10219b35d57221262fa"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b9e4fbf36466338f1a44a7b846d44f6cc50c74b82dca57e6e84307822df6d05" => :el_capitan
    sha256 "021407a242ccdd446db396f4df93ecdb6fb86138e04143807d2a56227a965fd1" => :yosemite
    sha256 "0b40e9481c209ec589910b149c3598504b1ea5d58e978c4d0dcbbe2a2e20f41c" => :mavericks
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
