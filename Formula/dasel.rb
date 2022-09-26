class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.27.0.tar.gz"
  sha256 "44fc7cee679bef849073f9a0fa0943423b930f7ca626b9af02cb7227c7cab07a"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c6585008c2d67c4a3eab71afc5267743323f8034921a775e2343c55db52f489"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd5dd9184e3a2b82d4ce4c5f03befce72795bdd794d4d05d0859d442c6f0522c"
    sha256 cellar: :any_skip_relocation, monterey:       "e8f05454b180a64d81625d27d3bf6e05b41a1e604362c495a5052cc3ac88f9e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4c6359135254cbfb67f307e719bdbb8beb8c2a3a670fc7d721845779cfa2c12"
    sha256 cellar: :any_skip_relocation, catalina:       "93740f53e2311b9b1601dde2cc707cd4dfcb3706c762fcbf26d187ba232f9bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f50342741f42df663ee35040f71f65caae494e45153fb176485f6cdf94b274ec"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dasel"

    generate_completions_from_executable(bin/"dasel", "completion")
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
