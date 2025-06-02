class Nmstatectl < Formula
  desc "Command-line tool that manages host networking settings in a declarative manner"
  homepage "https://nmstate.io/"
  url "https://github.com/nmstate/nmstate/releases/download/v2.2.45/nmstate-2.2.45.tar.gz"
  sha256 "af2cd67913c8bb0965ef8ee989276d0fb006f641e5a3e4fea0cf2587309feb59"
  license "Apache-2.0"
  head "https://github.com/nmstate/nmstate.git", branch: "base"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32ca21a11604f92b078aafc1a5875221d1ce7f753c14ea048c6fa4227d8b167c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70bf85d428ea7b50b376a7c4231a030caf0a24bb0e464654739665ff436b8710"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32719950099cec58d558210fb7143d0be9cc0a2cdb362b48d37c54fb821f5a2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef9cec3f17a283e3b1119c9e14c68f5df186cd76cfe57a5d9dba1628a02ffc3c"
    sha256 cellar: :any_skip_relocation, ventura:       "3f7babdb73adc00847b97052088bc9b5d60267e1935ff152e4eb77060a8fb2c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b652bdf0a449bbedd860d5a7f331fc03193c2bc4d0dd3d85377c45424f8e0c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39e08dd4ce5a51c7b79e57e4a4fe3f7b9f5453d3584cf89ee10089746c066ecd"
  end

  depends_on "rust" => :build

  def install
    cd "rust" do
      args = if OS.mac?
        ["--no-default-features", "--features", "gen_conf"]
      else
        []
      end
      system "cargo", "install", *args, *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nmstatectl --version")

    assert_match "interfaces: []", pipe_output("#{bin}/nmstatectl format", "{}", 0)
  end
end
