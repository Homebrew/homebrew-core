class Cloudquery < Formula
  desc "Data movement tool to sync data from any source to any destination"
  homepage "https://www.cloudquery.io"
  url "https://github.com/cloudquery/cloudquery/archive/refs/tags/cli-v6.34.2.tar.gz"
  sha256 "6925f67591bac8ac6938e123c77400251b70d39b2c0df58f58220ceb2d2479e0"
  license "MPL-2.0"
  head "https://github.com/cloudquery/cloudquery.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c92161d8c2e0a0afd4de1131261a29596d9ca83c0d2b9b94e87ae921b8386924"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c92161d8c2e0a0afd4de1131261a29596d9ca83c0d2b9b94e87ae921b8386924"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c92161d8c2e0a0afd4de1131261a29596d9ca83c0d2b9b94e87ae921b8386924"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b55a6028bc90f302235890f3f356fe35764556e6dfb64317b8c8f1985e5991c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fc8692dc84fbef9430fa735d73994d955b7f49e51830e04bc788dfaf408e7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "150fc9aa66f8d933afc82ef881749660b139ce489303472dd3c21a1aa9a5ab12"
  end

  depends_on "go" => :build

  def install
    cd "cli" do
      ldflags = "-s -w -X github.com/cloudquery/cloudquery/cli/v6/cmd.Version=#{version}"
      system "go", "build", *std_go_args(ldflags:)
    end
    generate_completions_from_executable(bin/"cloudquery", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cloudquery", "init", "--source", "aws", "--destination", "bigquery"

    assert_path_exists testpath/"cloudquery.log"
    assert_match <<~YAML, (testpath/"aws_to_bigquery.yaml").read
      kind: source
      spec:
        # Source spec section
        name: aws
        path: cloudquery/aws
    YAML

    assert_match version.to_s, shell_output("#{bin}/cloudquery --version")
  end
end
