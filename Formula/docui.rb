class Docui < Formula
  desc "TUI Client for Docker"
  homepage "https://github.com/skanehira/docui"
  url "https://github.com/skanehira/docui/archive/2.0.4.tar.gz"
  sha256 "9af1a720aa7c68bea4469f1d7eea81ccb68e15a47ccfc9c83011a06d696ad30d"
  license "MIT"
  head "https://github.com/skanehira/docui.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "17950b11df021726ebb04675ffc92c096e94ab213c32b803888ab3c16e360f60" => :big_sur
    sha256 "30638ca04ad60f4c2406405d151dad2c5854a6b7404dcb1d5be3917a93efcd14" => :arm64_big_sur
    sha256 "85812a1ae880fa35f8f03fb7632d6e1cae1288c673c02d5ef41763a998e1ce42" => :catalina
    sha256 "da3b5097f43474a93b7fd5d9cdd27c351b4c86214041369a7e3c41690574fe45" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    system "#{bin}/docui", "-h"

    assert_match "Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?",
      shell_output("#{bin}/docui 2>&1", 1)
  end
end
