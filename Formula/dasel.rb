class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.13.3.tar.gz"
  sha256 "0e57c8ef0bf8a2be05a2a84c5c46d1e349f2b22d7909149a93ecc27a9eb4b52b"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "25efecbfe4c21a418867a45bf32cfebd794bed47e51c479eac9ebaf9c2feaada"
    sha256 cellar: :any_skip_relocation, big_sur:       "fa5a62d274db514a5b60dcffe8f42d417dd8105f93eb086d8196b3fdc6b20c00"
    sha256 cellar: :any_skip_relocation, catalina:      "961e56078ed480df1be3b9f1a0928fa94cdec6b8af5a546766adfdecae5b7444"
    sha256 cellar: :any_skip_relocation, mojave:        "e6146f8bec214f83e93d8ae07d861de11d16d3be3d0d63a1d38e41e50bc488d4"
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
