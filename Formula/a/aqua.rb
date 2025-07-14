class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.53.4.tar.gz"
  sha256 "95c09bd56bd3478ce00a83df0c882851ecbd23555a6ad6e8300de24378723cbd"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "463147d057282bc960983ddd61c48391d7e8a3fc1d8537f3590c1fb0a970ad5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "463147d057282bc960983ddd61c48391d7e8a3fc1d8537f3590c1fb0a970ad5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "463147d057282bc960983ddd61c48391d7e8a3fc1d8537f3590c1fb0a970ad5b"
    sha256 cellar: :any_skip_relocation, sonoma:        "162b110d4657e97a65ff663cf7249a583a906ea5dbd44f40322f88e4ae075cca"
    sha256 cellar: :any_skip_relocation, ventura:       "162b110d4657e97a65ff663cf7249a583a906ea5dbd44f40322f88e4ae075cca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f5e5796749fa12422c553a0db4618c049c593a5eab0edf4c9c39affd826b6b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
