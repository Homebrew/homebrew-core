class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "9c11dad96140430ed2b48495e5658c67680c3d78351e65c82aad455b1c62618f"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c40bf23d36cc6931677739415ba1e18987ae751c2e6fe56200485206f5310b76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "417d53d73345f55e9962e3cb92ad5cb2d5392de6657532750752c4ee2a2590d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7854e5fa9a51023c20311dcd498b96ea3e6372a14f458f40038935f3a1d677a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeca7628917e0f61c4ea42368e3b7982e339f98ea272bc3ac67a99ae4e0b7085"
    sha256 cellar: :any_skip_relocation, ventura:       "1092806ce40c2799213a9bed89afcdeed5e3e645cecc4c756f10a4ab270c0b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4398ffe2ab6458524eb28d5c7459187e061ac04f1376dba1b320598d4bea6416"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "_carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
