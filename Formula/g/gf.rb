class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.7.1.tar.gz"
  sha256 "bc308219c6d35de27e5480b996a484ecb838aef408bf73600c5a251e735015f8"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "28ccb3aa11b40a974154fb311ab33cb2a58455bd9f050edeb6b36b34ecfb9e0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4025c6bb27860fb74f7bd41aab346411a7b6c0fd473ab50cbba302cf3ae648c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3251853af5b23087a548038d6c7dc411382d2d7f64ce624a6ff4de1c3e155c54"
    sha256 cellar: :any_skip_relocation, sonoma:         "58836622005e06d8df6bedbf5da65d8098c1ca8dca86998b08ec86e362ff648b"
    sha256 cellar: :any_skip_relocation, ventura:        "9217fcf76d8a8a9750564f54bf9223d9d5c84ee23ddc9c3a89ab23f97a0c640a"
    sha256 cellar: :any_skip_relocation, monterey:       "e02d2172a5a208b8983558e42e230885388c4a2ab7b0f92ec12128ea80c502ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "055100ebe4f6a007399059c9a0c74948d655e5433b2c2467db1bfd421007a8d5"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmd/gf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}/gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}/gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end
