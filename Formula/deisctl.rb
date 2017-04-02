class Deisctl < Formula
  desc "Deis Control Utility"
  homepage "https://deis.io/"
  url "https://github.com/deis/deis/archive/v1.13.4.tar.gz"
  sha256 "c59b244b2d4e87e04491898a401238ea6f302326957ffe1aeb6154485fe1d8ec"

  bottle do
    sha256 "39a9a5939d7a3442fa9a69e6b1c9982d9cadbf97e78ab779e9a9b42d269c8596" => :sierra
    sha256 "061764d9b8f99601aa089c52d897b142b5964ed89d52fa9e9ab53d3b20f332f4" => :el_capitan
    sha256 "93e2c308bb2005ca7709b52f50c3c7f092cb83046417b4ecf88cef02dea2ea72" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/deis").mkpath
    ln_s buildpath, "src/github.com/deis/deis"
    system "godep", "restore"
    system "go", "build", "-o", bin/"deisctl", "deisctl/deisctl.go"
  end

  test do
    system bin/"deisctl", "help"
  end
end
