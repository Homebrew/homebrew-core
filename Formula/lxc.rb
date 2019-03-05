class Lxc < Formula
  desc "CLI client for interacting with LXD"
  homepage "https://linuxcontainers.org"
  url "https://linuxcontainers.org/downloads/lxd/lxd-3.11.tar.gz"
  sha256 "5d38ca401aedbba867f2b8b4cb491efe85047dd0729f22b31ae2feef21cfbf77"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fe60bea04e48fbfe859708ab7dc5bb9542d4e7355a49a428e6e7e086668445c" => :mojave
    sha256 "8239ec9949161ab27f9bad4aa6160bf3bb19647768e2d8e62009b372495d4487" => :high_sierra
    sha256 "1dd797dd601c514000191f57636ebd1ee4c9bee4a6da1fcdb6a8e5a738a025ce" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin

    ln_s buildpath/"dist/src", buildpath/"src"
    system "go", "install", "-v", "github.com/lxc/lxd/lxc"
  end

  test do
    system "#{bin}/lxc", "--version"
  end
end
