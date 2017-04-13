class Hyper < Formula
  desc "Client for the Hyper_ cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
    :tag => "v1.10.9",
    :revision => "1ed5d3fd838860558b757336b578fcb9bfb22499"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e96c0667ec6ed680eff7692a317f49b89ab43d1b4ca31ef3d14d9543a4eced0c" => :sierra
    sha256 "dd45159e0b6671d514e13a627811f5fdd7eb2dfe56a610dddfe36616558d00fa" => :el_capitan
    sha256 "1520a0901d876635429a6d21f427719112442272775ef5949d176a57b4feb8f0" => :yosemite
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
