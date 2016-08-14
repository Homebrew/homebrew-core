class Hyper < Formula
  desc "Client for the Hyper_ cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
    :tag => "v1.10.1",
    :revision => "bfea818f0bd5f2c8a19106b8f7997edd1878a631"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc899a09743f1be44035ba8d367d4254566ec46680d0bc77081994758b1d04a3" => :el_capitan
    sha256 "b282ec27a3fd819013ab114fec8efd811876e9f9a46bfe0c711068d32bce2ac9" => :yosemite
    sha256 "7076daae711b9e87b93636d94121e89b73389bfe5fb6fde36623ed5949d0952d" => :mavericks
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
