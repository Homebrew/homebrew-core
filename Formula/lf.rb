class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r23.tar.gz"
  sha256 "ae3a7d11e0b87ddb9fef2dc61de4c6f648039138fc69975cbdbd9fe126daa71c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "72f7928598fd4a865ad177bc56128f85a19f1aca4a09fdb74b5eb8868b67cf16"
    sha256 cellar: :any_skip_relocation, big_sur:       "935d3774fe9c1178a8fcab0ac39e4f1f5c0a797b766dcdc4d8e0b03b047549e7"
    sha256 cellar: :any_skip_relocation, catalina:      "a42e53d45629dcd7dd2e750bf334e59067c367ff2b270e990472629a48f207e7"
    sha256 cellar: :any_skip_relocation, mojave:        "40d27d166e75377759a8fa09a452fd776533124cb7a2e21207d8020d999d462d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.gVersion=#{version}"
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
