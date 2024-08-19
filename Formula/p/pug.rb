class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https://github.com/leg100/pug"
  url "https://github.com/leg100/pug/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "6d854c8d6fc9780d557527bcf269e4885fc54216e4c9d0eb52d4fb9cf6fbda08"
  license "MPL-2.0"
  head "https://github.com/leg100/pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6835948b520989c9540cc47b98786a9dc459e29ff72471f5ebea2a1a9411f7c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ec0e2cb0161668933463aa4bfbdb3bd77b0cc3327fa12899679873c845c4722"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "209418dce6af1b0d7776bd4137bf7c5d56a5129ae7cc29b4abda6bca11514c22"
    sha256 cellar: :any_skip_relocation, sonoma:         "97d8a3f46ca97b960f53d173821a7c4bcbc829cf9d20195afa0f18cde297355a"
    sha256 cellar: :any_skip_relocation, ventura:        "06bdfa9cea828c9ce4d928ffeb65d08e69a6c8434ad34bcea561decd9adb9230"
    sha256 cellar: :any_skip_relocation, monterey:       "b4c6e378fa785e7db2c7f703c36409e6baa59f33f3f5ec62936cc895edb574e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "697d981074a52b47456c6d58d022057e48b7d515d85a47e0f5aae87da360ea83"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/leg100/pug/internal/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _w, pid = PTY.spawn("#{bin}/pug --debug")
    # check on TUI elements
    assert_match "Modules", r.readline
    # check on debug logs
    assert_match "loaded 0 modules", (testpath/"messages.log").read

    assert_match version.to_s, shell_output("#{bin}/pug --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
