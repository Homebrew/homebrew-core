class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.51.2.tar.gz"
  sha256 "00c8750d56000555a489b97d073077bfaaade18ac2c308a28b7b336e242f065e"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41f94149f7b10784db9f353a2faa2d680c93cafa344e1a24bf686be8c39bee17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41f94149f7b10784db9f353a2faa2d680c93cafa344e1a24bf686be8c39bee17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41f94149f7b10784db9f353a2faa2d680c93cafa344e1a24bf686be8c39bee17"
    sha256 cellar: :any_skip_relocation, sonoma:        "39140c57a91682d020ca3365b7425d68d00a66659e5da70ca4e1e90323136b44"
    sha256 cellar: :any_skip_relocation, ventura:       "39140c57a91682d020ca3365b7425d68d00a66659e5da70ca4e1e90323136b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b52321eec81612465a3c72ea0e541787125af69c3ae78f27aefd2adc47e3f897"
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
