class Pumba < Formula
  desc "Chaos testing tool for Docker"
  homepage "https://github.com/alexei-led/pumba"
  url "https://github.com/alexei-led/pumba/archive/0.8.0.tar.gz"
  sha256 "052ece6984a0533d7f93b2b64c66d5e89516bbf93e4cb732a2743322b4eef9da"
  license "Apache-2.0"
  head "https://github.com/alexei-led/pumba.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4e195c3e36f7dde3821a76612e9ec9a7eff6ac764e6e11b37970824d17e39a6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c06d9a93dafd07b20b289c16a233757e195796c58bf6fb4e37485cb73641e83"
    sha256 cellar: :any_skip_relocation, monterey:       "002f19f642435422f482e87bb784209ebad478026f23cf3f2622456ad8e145d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c110eb1c6fd9553ccee5327c4c3d556e9c58d120c9a8a3ed7eb1f901e43d25e6"
    sha256 cellar: :any_skip_relocation, catalina:       "f007ae66a3b66626df7f25c83788728db253f255805920c16db32e1319a6a172"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9c9e8801b3949b92250902db1fe9cf35913ab937d4aae83504b87f8a9917488"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}",
           "-trimpath", "-o", bin/"pumba", "./cmd"
  end

  test do
    output = pipe_output("#{bin}/pumba rm test-container 2>&1")
    assert_match "Is the docker daemon running?", output
  end
end
