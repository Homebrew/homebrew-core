class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://github.com/TomWright/dasel/archive/v1.21.0.tar.gz"
  sha256 "eaffc677863aff7d6c242c9fe247a83ef742a99355ecf7586110ce8682db19d0"
  license "MIT"
  head "https://github.com/TomWright/dasel.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b494402aad539bf0d8fa23f6c88177119609754eae482ae7dd607c067a205569"
    sha256 cellar: :any_skip_relocation, big_sur:       "79a945065caddbd3f4d643e2e67e844c32a54ab97c9deb451dd2863f64dc6060"
    sha256 cellar: :any_skip_relocation, catalina:      "ec290cfe3b50b7c49c9c1438d4f38dc274f119239a94f951df89848dfe133123"
    sha256 cellar: :any_skip_relocation, mojave:        "969d7e25e12dd1ac7e5bb8bc34f33a63baaaba1ff52f3d2d58573482b370b8bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd711603701a1c46765eccb5be8e8992b1c3478bb324ad5c398b620deb45935a"
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
