class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "4940eca5e52f1256f352b7958166456bf0e80c0d044a2b3eca63f2fd3cc3309b"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21fc3903f93aff6cbba336e2f31df031c37e933a1bccd00e969ddeab8c36c60b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21fc3903f93aff6cbba336e2f31df031c37e933a1bccd00e969ddeab8c36c60b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21fc3903f93aff6cbba336e2f31df031c37e933a1bccd00e969ddeab8c36c60b"
    sha256 cellar: :any_skip_relocation, sonoma:        "efe22175b0f2ead46f3837499d3b6ce5663a8f06bd27b3e5ae2f143beefc5d20"
    sha256 cellar: :any_skip_relocation, ventura:       "efe22175b0f2ead46f3837499d3b6ce5663a8f06bd27b3e5ae2f143beefc5d20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddc1d86e88c93fe51ae81ef0f38307b965afbfd1f18a298c5180dcb706d69e63"
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
