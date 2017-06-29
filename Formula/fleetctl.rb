class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v1.0.0.tar.gz"
  sha256 "671326e84b39714c513a6a6e36ba8375a52ff7114f62eb81fa4b0f8c44c44424"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c3f5b1d6328290f2252d4ef8a2e1dc44ab789603b9bab00ef272eba58bf6bef" => :sierra
    sha256 "9972537338178f9cf3b1a16d947cd2ca77b3226688c18bdc43e8b269e139bde2" => :el_capitan
    sha256 "945e9eb7fc85dcbbf11840f9085dfcb01834af14bfc45be0a4f480205f6077a1" => :yosemite
    sha256 "11d48264d9e7987defd5f06462601261a6b861e666597d49db90ef4977529cf7" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fleetctl -version")
  end
end
