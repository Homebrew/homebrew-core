class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "c2c3924c814ef56555a57cc022a3663ffc025965025618bdbb5cf1ee120ddece"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bf5e2e9985e08ba9427b2861faa4c06e5c64d4c761b2d8b98332135fb51298e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "462a07fad7288b28875833b2cf83d202ba4c0a5cf5377d2fc70440aaed174df9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "462a07fad7288b28875833b2cf83d202ba4c0a5cf5377d2fc70440aaed174df9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "462a07fad7288b28875833b2cf83d202ba4c0a5cf5377d2fc70440aaed174df9"
    sha256 cellar: :any_skip_relocation, sonoma:        "19f5c656c939a36a0e0cd6c0ccae1db732b59dbe900a37df284ac3381e7e7d63"
    sha256 cellar: :any_skip_relocation, ventura:       "19f5c656c939a36a0e0cd6c0ccae1db732b59dbe900a37df284ac3381e7e7d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd7d253a8062882ea00c364c76180d9b361a2f7426c98b437793cfa49eb82803"
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
