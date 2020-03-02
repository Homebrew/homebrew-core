class Gotop < Formula
  desc "Terminal based graphical activity monitor inspired by gtop and vtop"
  homepage "https://github.com/xxxserxxx/gotop"
  url "https://github.com/xxxserxxx/gotop/archive/3.3.0.tar.gz"
  sha256 ""

  bottle do
    cellar :any_skip_relocation
    sha256 "" => :catalina
    sha256 "" => :mojave
    sha256 "" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-ldflags", "-s -w", "-trimpath", "-o", bin/name
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/gotop --version").chomp
  end
end
