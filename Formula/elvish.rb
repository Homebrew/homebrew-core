class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.14.0.tar.gz"
  sha256 "36ed5e0318d75f7e7d616398e42477cfbd6fd2a1d1f108dee7941621cfb7378a"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2248775555e32f6c93c30851f8ad6cc268b3c0b8365625b90bcb116cdc7fd251" => :catalina
    sha256 "d5d4b767f9ed8a5fbf1e27ca857d5afae6bde95b178c00430fdedab7c1cfbe72" => :mojave
    sha256 "2e341bc1fa4614a3d807771f74d9034aabbe9bc14ba7487697a62ea38d3ddf6e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
           "-X github.com/elves/elvish/pkg/buildinfo.Version=#{version}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
