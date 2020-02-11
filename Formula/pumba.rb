class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.7.1.tar.gz"
  sha256 "18be4bf40f25c7f94ae28dbc5751bad11aa7ed4cd832e4a738e54e4f20798df7"
  head "https://github.com/alexei-led/pumba.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "503c1d02632b7c740fbbce076af1c5aca78ef2bf95bd844b87bd253873365fc4" => :catalina
    sha256 "4ab6c9e97b3e929facf6098442403f505c037ab40311a81c62a61a4d14265b62" => :mojave
    sha256 "fa003e755d63db13cdc5c3d259c87a59ccac26cf7745b8eb293bc17e96477626" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}",
           "-trimpath", "-o", bin/"pumba", "./cmd"
    prefix.install_metafiles
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
