class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.11.8.tar.gz"
  sha256 "22f2f40c1c2938504b31e9dbb54eb6eb54569458a4dffe5e0020e917a5e1f66f"
  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e588b72b8f5cb8424a9051b3cf605dcb135009a5c497f68d2837594da981153e" => :el_capitan
    sha256 "9205a4f52701c711087ce698af69bd995f719c342b2ba9675cad12779a85cf67" => :yosemite
    sha256 "e5fbdaff63cb5908702c76f8dcffd08d2811f5cb5432b1bf8931af9eabaab84e" => :mavericks
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
