class Gtrash < Formula
  desc "Featureful Trash CLI manager: alternative to rm and trash-cli"
  homepage "https://github.com/umlx5h/gtrash"
  url "https://github.com/umlx5h/gtrash/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "66003276073d9da03cbb4347a4b161f89c81f3706012b77c3e91a154c91f3586"
  license "MIT"
  head "https://github.com/umlx5h/gtrash.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "36c16ed00744a249888b082cf1beae2498baf11f9f484e52f60bbac02e75b28d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "857a779ba0bfda17f825bd37e0c694b39abe6c85ff518432e0904026643fa9d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "857a779ba0bfda17f825bd37e0c694b39abe6c85ff518432e0904026643fa9d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "857a779ba0bfda17f825bd37e0c694b39abe6c85ff518432e0904026643fa9d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3596f9c58e086381b19eaf305f014e68f6f000fd7ef05a074f5531f474dccb15"
    sha256 cellar: :any_skip_relocation, ventura:       "3596f9c58e086381b19eaf305f014e68f6f000fd7ef05a074f5531f474dccb15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f999d88ee8f19088384800b64e9e9924df91ecff3dd2db2b674f07f3d6bc808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e297de1658a618cb06feb006a9a5498e313aad3ccfcecc11430ef645f129fe"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gtrash", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtrash --version")
    system bin/"gtrash", "summary"
  end
end
