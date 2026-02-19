class Jet < Formula
  desc "Type safe SQL builder with code generation and auto query result data mapping"
  homepage "https://github.com/go-jet/jet"
  url "https://github.com/go-jet/jet/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "d08ad03aac750cccb82d5decc57e0f7040aa866f3b1028079a052726875632cc"
  license "Apache-2.0"
  head "https://github.com/go-jet/jet.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9e5b2da17f204428bd9e47d751750a47bedbb73e4934991cf6ce37a9d448ef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e137024ad8955f0364c4e738b53bbf49835fb20cd9ee0de764661461bc140a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1599211d902478a5bffc4b89d2cd564fb55fc77b052cba0d08d64e5e99856a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "22deb92d0d620fe7075681c0e4b1582e07778679199b066b94a883796a3a6e2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b568589a19ca662efa63dfb64bca31b92b22442b2aff7009d88bf073e56b38f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "629d53e3b9234713aba15fd7e572cc1298aee75a4fc0545fbcf255349e15190e"
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
