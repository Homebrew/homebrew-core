class Hyper < Formula
  desc "Client for the Hyper_ cloud service"
  homepage "https://hyper.sh"
  url "https://github.com/hyperhq/hypercli.git",
    :tag => "v1.10.10",
    :revision => "a94e549f5f7ebfb23323ff79ad7304e59f1cca77"

  head "https://github.com/hyperhq/hypercli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43a75f74013fd56a40eade63d34ee982368b796c7e4847e9702948981a926c65" => :sierra
    sha256 "d42ad5d4ffb61146e2ed98833bd614327eb519c7d2bf0629eedbdf3e8c867aed" => :el_capitan
    sha256 "8e379a80d90195d88cd2a62b19d9c1ea111c670dc0819f47a436748601652759" => :yosemite
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
