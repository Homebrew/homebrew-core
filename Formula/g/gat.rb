class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://github.com/koki-develop/gat/archive/refs/tags/v0.30.2.tar.gz"
  sha256 "47e4c84f898fe0022f0add0fcd1649a1b77c0b6c452b4e022645523fb1955f57"
  license "MIT"
  head "https://github.com/koki-develop/gat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75abc4d9b60e3d3955b9e3d24b481cd2a33d342f85ca9b9f8e5239ed912a4be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75abc4d9b60e3d3955b9e3d24b481cd2a33d342f85ca9b9f8e5239ed912a4be6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75abc4d9b60e3d3955b9e3d24b481cd2a33d342f85ca9b9f8e5239ed912a4be6"
    sha256 cellar: :any_skip_relocation, sonoma:        "2362abb3f9b54e1f3a05688ce749b8097da19919bddceaf458d8c83d23008ec2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "400f6bb4eaf14a4427376ec9952f7555cc96eba27dac33262b16cf02c222172b"
    sha256 cellar: :any,                 x86_64_linux:  "b89182c4997bcd94b54271d03268722d6a5ae05954a63ec2a92968d6802c1b44"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end
