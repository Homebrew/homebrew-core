class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.20.0.tar.gz"
  sha256 "be5879daa5e06d693d133cb56e0d9255947ca00e50fa6cc9b05a9c63c9ed93bc"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fb9ca6d977364f4d7173e8d6b828c7c71d7b81865e87778cb2e5c1ff7c23e6e4"
    sha256 cellar: :any_skip_relocation, big_sur:       "1c9ff6be25c9ec6b9e5b69e5aa3bc80b47c6f168fedf329af8184bd80196d779"
    sha256 cellar: :any_skip_relocation, catalina:      "cdfd641a98f4cfc82b3b579c9d1defe66520185beb0b8ec453543af7b0a214a6"
    sha256 cellar: :any_skip_relocation, mojave:        "eec58543290d7f1500dc9396e45c27656e51f12a08c34246daaace04d3440513"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb7e51b4e1bb22f7e25a8122fbd6f9c0c4a9583604df3dfced3fc14563c5f69f"
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
