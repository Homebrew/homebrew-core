class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.53.2.tar.gz"
  sha256 "88f129148c94e3b5377e9b34888851d247db3b1c655a9c38ec6aef9a516cd932"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddc06948539a8d19d1c5c4bd3c4f4fe296d929a35876f89ba554b9a01808e7de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddc06948539a8d19d1c5c4bd3c4f4fe296d929a35876f89ba554b9a01808e7de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ddc06948539a8d19d1c5c4bd3c4f4fe296d929a35876f89ba554b9a01808e7de"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cdcb0e1a28020b058d3d4530c95e07dfe86a25e1f1a005feee5d4893e71380f"
    sha256 cellar: :any_skip_relocation, ventura:       "1cdcb0e1a28020b058d3d4530c95e07dfe86a25e1f1a005feee5d4893e71380f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b37a6f8790cee25ac93aa4bb45e0727e1aae83f9ee55951bb721fd6c96cdfc59"
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
