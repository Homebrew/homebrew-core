class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "31d74e7a9027a75cc19419b43b8839d67fe4aa7f6a042c67e54be1548dc141e6"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4d7a8a438475499ad52ea4fc1777812671d01423c5e4dfc2aad975eded1c888"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4d7a8a438475499ad52ea4fc1777812671d01423c5e4dfc2aad975eded1c888"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a4d7a8a438475499ad52ea4fc1777812671d01423c5e4dfc2aad975eded1c888"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef452d21db984ffa75e083a8829f0688f1d41de9f72df7c3288cb1eef20d7363"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2269f3db515de33608d4c9638318b6cb73b3bd7a91631b1c6e7882a30a1189be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4483f55ac441f0c233fd906ce76c9c296af1f62e8b37fba20bc10609dcbaf99c"
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
