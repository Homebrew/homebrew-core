class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "363ab0fd7ceab99c02c5ad3098f19783f01f3c2b8b234b8c672be69d86f92a15"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7120a4453f38b866a337ead4d3797252c99247ed15eba6d3e019cfcc9ec101b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71e568ec32e2715fb2c0a53edd697d4d07629b381875503114e296df957f41a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97eadab432599d0d3e6477d11881c38d79b03f35434c4d9d404709a264474a76"
    sha256 cellar: :any_skip_relocation, sonoma:         "db3a87e5519daa260046f4764975cadcb462a21f7f46b9eef52faecb941fd5a8"
    sha256 cellar: :any_skip_relocation, ventura:        "eb368fd2450405fe49162cee8d56d3828e0346cb3b66ceac08935e5da1157b8f"
    sha256 cellar: :any_skip_relocation, monterey:       "db7e9f31e18cbd5641c7e54392f2389cf6a5638a81baf1223d0cee9f8a4e85bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce3c9e5ac6b60466294cac48841a325edb79e836df54d2df28480d4494a277d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
