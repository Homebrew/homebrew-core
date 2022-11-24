class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.6.2.tar.gz"
  sha256 "d079cf94f791a93f0976bb9aa4296b0f3df27d379e3a2054b8c6a50e193bc6d2"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b96dabb1463c45a5712b0d8d0cb3c375b8b35072156e68095ebc4948626f8353"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5b674022320824926fc3ea853b87de186dd31c310fc1118622f11dcd380f846"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d49a42370922f06ef2ac7165a65578e456eadf392f48eaa2f070d010ff617d0"
    sha256 cellar: :any_skip_relocation, monterey:       "b59af6ee74ca34cb0393c01bedf41fd73bc6790d2131a1249eb0b95e2d03d204"
    sha256 cellar: :any_skip_relocation, big_sur:        "63e4208e32c188935346b3902b212576a623ad3585e4dc9d9aca013b1fbe2585"
    sha256 cellar: :any_skip_relocation, catalina:       "49453b242f88d336505320022c65dab64100b481a492d724370809a4c7d833e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bde31c8f1a163c139ba871ca411f61813d276c45f59b1ecced6041015e87a5d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end
