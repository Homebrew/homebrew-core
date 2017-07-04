class Elvish < Formula
  desc "Novel UNIX shell written in Go"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.9.tar.gz"
  sha256 "41aed14f500813c884a0a8b6c4ebbcdf233b2d139f1d10cea697d597007f1698"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "798b87a13d8df584485dd03984a89418024dbf87212a3a63891481b97c4ee325" => :sierra
    sha256 "fe54f770b4e487a2dd6d907d7e95091db0f020a0ca5aafba198f34f0bc9c2848" => :el_capitan
    sha256 "6d5e348ae39b40755d4f81126853c964e2a8ec6f0172ffd1c9ee789ada4bf558" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves").mkpath
    ln_sf buildpath, buildpath/"src/github.com/elves/elvish"
    system "go", "build", "-o", bin/"elvish"
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
