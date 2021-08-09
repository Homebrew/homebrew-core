class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.17.0.tar.gz"
  sha256 "d1e68ba1e142f04dd987b2ed9a8bc179061db101af12a4e78e8a84d033c46a39"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5c026be414bb148ef77b874e724f429633372db12258b7019dc386b6b1749de"
    sha256 cellar: :any_skip_relocation, big_sur:       "b91e50810bcf7a2372978cec9ba76e7d072331a1b24c325f202a769be82ab97c"
    sha256 cellar: :any_skip_relocation, catalina:      "0dfc38632a3528996cc11d48a0959ca0ec746a2104f95d626ba18ffa096461ef"
    sha256 cellar: :any_skip_relocation, mojave:        "2f3e3d23054e43943b304087d6ee6992dea46d121cd6bf3af68b7bfc4f681134"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56acd1f7525b11a56504178ddfa41297e731f82b204887568d018fa157d6f70a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X 'github.com/tomwright/dasel/internal.Version=#{version}'"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/dasel"
  end

  test do
    json = "[{\"name\": \"Tom\"}, {\"name\": \"Jim\"}]"
    assert_equal "Tom\nJim", pipe_output("#{bin}/dasel --plain -p json -m '.[*].name'", json).chomp
  end
end
