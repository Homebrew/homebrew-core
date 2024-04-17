class Gf < Formula
  desc "App development framework of Golang"
  homepage "https://goframe.org"
  url "https://github.com/gogf/gf/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "95c93b344ba6f98bcfad1e49987cbaee4bdc69a794be7588dfe5cc77aa6b5640"
  license "MIT"
  head "https://github.com/gogf/gf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dc34ba733db753da047d6c194d197ef16cf04fb52a1757986d879292d8fa2cdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0598fb4f21be0f6b4d9a331c7e7c9b1e1a404e0bc9e88ce1367992d42da9a20a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c0024c5f946fa184cf10ee7c054c7d4fdfe80cf4994ff2fd73d8a060c34f34a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d7a53bbc965c2eede8f9bd3981e52e49d22a406b3fcbf0fbcae8f87c76a52a4"
    sha256 cellar: :any_skip_relocation, ventura:        "b03b311c251b5aa5d072631b86043accb90d88a5c68c90f9de03309ca2e25a0e"
    sha256 cellar: :any_skip_relocation, monterey:       "4d0304f8f3cf4e5a18ceff8c74229b72cb4a358c9d785222b597ac68d6fcf0fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e49761a2cb7f1496af26868b00035e0f2ec6e785db2afe9259bf4c37fd5fa0d"
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
