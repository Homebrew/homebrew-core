class Hostess < Formula
  desc "Idempotent command-line utility for managing your /etc/hosts file"
  homepage "https://github.com/cbednarski/hostess"
  url "https://github.com/cbednarski/hostess/archive/v0.5.1.tar.gz"
  sha256 "9fbff04becc3d65a11de24f03604190eaafeb5f5117df297bdd84fb2df58c1ab"
  head "https://github.com/cbednarski/hostess.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a9d9913afdfdc168e8cde3851e4d3aee36a3f29cbb37c7eee553146b5e4c87c" => :catalina
    sha256 "04ea74921e0739da95c77825f1e7c1ba95b045ad7ed560dc236cf18ff66dbf09" => :mojave
    sha256 "a4ee18464f1ae186c1281dc17a3ed6a65c1d7ffd585e97cdf4d1d872e4a5575d" => :high_sierra
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
