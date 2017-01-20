class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "https://deis.io/"
  url "https://github.com/deis/deis/archive/v1.13.4.tar.gz"
  sha256 "c59b244b2d4e87e04491898a401238ea6f302326957ffe1aeb6154485fe1d8ec"

  bottle do
    sha256 "274ce1639c8b85fff3fd4a315e260ac37baa5d66b52357d4d08b45cefa29cb15" => :sierra
    sha256 "2ac131bc5838ab6970cb6fb8269491c6eaa1ba4520c73ff4f0544d4b818c673b" => :el_capitan
    sha256 "a0b0c61cd39b47af6262a7fa13ad6b6d02118cc233b8bd78303172f3d0d02e83" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/deis").mkpath
    ln_s buildpath, "src/github.com/deis/deis"
    system "godep", "restore"
    system "go", "build", "-o", bin/"deis", "client/deis.go"
  end

  test do
    system bin/"deis", "logout"
  end
end
