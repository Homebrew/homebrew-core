class Hostess < Formula
  desc "Idempotent command-line utility for managing your /etc/hosts file"
  homepage "https://github.com/cbednarski/hostess"
  url "https://github.com/cbednarski/hostess/archive/v0.4.1.tar.gz"
  sha256 "d9450fe50e15da7dc5c577d600f94945c667f0867f34badf1ef845abb5e65b38"
  head "https://github.com/cbednarski/hostess.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0b8140a1f3d8c97868c218626fbc935ed592abaa6be72dcca368e36b62869db" => :catalina
    sha256 "d9d5adeeb0551a9bb230b09b8463aa098abf42e2e5df4392ed7ae8236c6b4ce2" => :mojave
    sha256 "955705aca89353471ac63e07a9254ca4252546c8071eda85a8b95ac6aa0b6331" => :high_sierra
    sha256 "6a5ca47a7d0047d1595c79008ffc5d9a43ce8ef11cea5b6fc7deeaa239102216" => :sierra
    sha256 "e77cffa19bdf7feb4973d59c4aa0f1551dc74b8caaf35c8a6330e71e223e2bdf" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"

    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-o", bin/"hostess"
  end

  test do
    assert_match "localhost", shell_output("#{bin}/hostess ls 2>&1")
  end
end
