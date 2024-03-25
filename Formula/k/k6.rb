class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/grafana/k6/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "9b7c80191fa49a8c6c2b959f20d45e316171c277730e3bc99d825294b4fe2452"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9968ca60e06a88ec1d55c780d3c6ff2b18e72ecbad5166f3b4902585284bb34a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17bef8dded4cf47186f3c704fe747499495b3d610558dafeee5889cbf3125a29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32b3e4fbce739fbe0353a838812c6a7bb9258fe6a7de219bc747eaca43a3f962"
    sha256 cellar: :any_skip_relocation, sonoma:         "adc221f11b6f1f422af9108b49108b21d7a951255274f314c6711c91f521d419"
    sha256 cellar: :any_skip_relocation, ventura:        "7f4b606fd1f64600cf092f0728093e670369fca7320476a051c10c9e9034e095"
    sha256 cellar: :any_skip_relocation, monterey:       "5300b6e31a9f4a1afe467014e4926806e8654b4c1d1749ed10b7e32a244c654c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfa18b1b729e74069a6121b8f15c9cd3bfccccc4473929e81286846121765412"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"k6", "completion")
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
