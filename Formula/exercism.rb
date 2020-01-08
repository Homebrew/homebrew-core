class Exercism < Formula
  desc "Command-line tool to interact with exercism.io"
  homepage "https://exercism.io/cli/"
  url "https://github.com/exercism/cli/archive/v3.0.13.tar.gz"
  sha256 "ecc27f272792bc8909d14f11dd08f0d2e9bde4cc663b3769e00eab6e65328a9f"
  head "https://github.com/exercism/cli.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fbdd9c6610651d7ec5fdc379c3223ad2468d8de8b8a65816b926a716f2267291" => :catalina
    sha256 "1ff0a848544a5ffd13cf7c22d93b5a63c642829d6cfbde484ca4ef12bae146f5" => :mojave
    sha256 "1c3903b2b675134e874b8a35a05744c161ca7feb0b13b171b65c50b3ad326045" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"exercism", "exercism/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/exercism version")
  end
end
