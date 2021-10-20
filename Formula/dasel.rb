class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.21.1.tar.gz"
  sha256 "b97584a5139329c00bf0c9f888f712c0af3168c469896de5deba756acc630bd6"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "25888c8f40cc7212ebf063e018e409e4f731e4775e349874ea1e4a4a83fd4514"
    sha256 cellar: :any_skip_relocation, big_sur:       "724cd8114e062cf974fe8867465e59e3cd86ebedba02e450abca944fd7737c6f"
    sha256 cellar: :any_skip_relocation, catalina:      "3a270b4986d0a042bdc6f90d205fb905056b56cf6e6236565408400ad84e8408"
    sha256 cellar: :any_skip_relocation, mojave:        "25e5745d735c7deb9bde5742848a84c8683f6209a425504ca10ce7d10a435b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "449588446a0e1696d7ee08cc0ae88e400d84d164e4ebf4a3a2d3a0ce154b3fab"
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
