class Jet < Formula
  desc "Type safe SQL builder with code generation and auto query result data mapping"
  homepage "https://github.com/go-jet/jet"
  url "https://github.com/go-jet/jet/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "4003b5c8188937031bd0a89e8442b5afb9c687e8b488d31eccbaa2895c42b4e9"
  license "Apache-2.0"
  head "https://github.com/go-jet/jet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c010d2b36641394ac115bb7fc445e9e5e291128900d0a78ed443c820ea2a41f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f45fc3dbb06636d172e43877f9aa3ad5a540d759259340f81b46b1fce44acb5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "291b20bb8a1ad9fbfb041a62970c1e28d44d7c5c0015d9bcf719ca6b8f9b9558"
    sha256 cellar: :any_skip_relocation, sonoma:        "506860133d5ea4bc6d3c83f119a3ff666381326185ec29317e218fb74f81a49d"
    sha256 cellar: :any_skip_relocation, ventura:       "54bd30e44b46376d305b9c6de7350ba5eb33282c767413ddd625be5323d86be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59978daf20497c7dda0ec7dde02caba7958a832bd0c90a30f8258d8d278b88a8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/jet"
  end

  test do
    cmd = "#{bin}/jet -source=mysql -host=localhost -port=3306 -user=jet -password=jet -dbname=jetdb -path=./gen 2>&1"
    assert_match "connection refused", shell_output(cmd, 2)
  end
end
