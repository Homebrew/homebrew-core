class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.26.1.tar.gz"
  sha256 "44c90753cf4c1b6e7fb82074c6701fd4b47dc6dc26fe4e5504dcccb4d273b946"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2814792a3c59c272215e9463a76ccd297ee0286b825210277b4e6c04315d4322"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35bbbc6622f9450d9a28a815f620405ae8899a1cc62f5696dd07f0f78586c153"
    sha256 cellar: :any_skip_relocation, monterey:       "30625642be518512370ebb512c4bcaff060dcc32fc8e2aa8ba98dc1ee9eba0fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "021522444b0c157afb1ca5a14e704a26f37a45c1e6050e68286db3af6d3e5a0a"
    sha256 cellar: :any_skip_relocation, catalina:       "bfa2ae611dbf92057792b73c24c02056bf739b80832363cc4bee8312a5d43cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f520f53c7f636badf25cba30671bc8448b7ad92925c5f4337f3584937ff1a61f"
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
