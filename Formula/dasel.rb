class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.21.1.tar.gz"
  sha256 "b97584a5139329c00bf0c9f888f712c0af3168c469896de5deba756acc630bd6"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "45a1accda4d6241c29369c9191addb0388118faac185369b243890df02def735"
    sha256 cellar: :any_skip_relocation, big_sur:       "03804a404d81a056011d9e800187426a0cc34d6201cc9b57a36aa936c7c8cdd7"
    sha256 cellar: :any_skip_relocation, catalina:      "5b2d62bc1772ae75b8c8e294a4f28572759906fde81784d4165801b8fd237e2b"
    sha256 cellar: :any_skip_relocation, mojave:        "c6daec8f6718360d85f21c3dc4a44ecc656d2ed3f34ef8a931fd0ecf45e748e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcdb4906918aa19478f4cadfef9a563945223cc67c7f0b59988ddb2e30a6662b"
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
