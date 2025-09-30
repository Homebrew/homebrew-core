class Pgutil < Formula
  desc "CLI for performing actions with ProGet"
  homepage "https://inedo.com"
  url "https://github.com/Inedo/pgutil/releases/download/v2.1.13.1/pgutil-osx-arm64.zip"
  sha256 "9a830eaf3cd079dedd262b25e13949281c910d5475ed267f0765cb15b5b0daf0"
  license "MIT"

  livecheck do
    url :stable
  end

  depends_on arch: :arm64

  def install
    bin.install "pgutil"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/pgutil --help", 255)
  end
end
