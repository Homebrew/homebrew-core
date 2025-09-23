class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "37539fa3b8bd0847131df33f568c35c22d958f9b39316e247063e38dedac4bc5"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ceaf3f4a574bdb16e6c8cf9435dd6ad634c60984ada17102c11f190ac4f85031"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b476b7884f53f5819f5451cfb94a03626291811ed0863ac7e5db728a3468862f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c6a6455e55d4c59c23a669cdf026f5d8820e65f4eaab9d1bde78a214d68c083"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a17af8314205a29ba1aa5ce2e078ba423b36d7832daa04b5f29ad5cacc90088d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9e519ca64d20bd22cbe34a5f1d879b82efce33d5a0bb89a06d75f6384691561"
    sha256 cellar: :any_skip_relocation, ventura:       "8f39d007f3eb896ba0ada58f7ea5714ec45acf0cb9f9add5a045cce8d1383cdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa744a049680c6e24b52a69428c63cdf17dcf05ee87769e4479d50a3dd03f722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66699bf9a46777c30997f54a2c3c574025c944c796020801e7a8fe2916e54a6b"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/falcosecurity/falcoctl/cmd/version"
    ldflags = %W[
      -s -w
      -X #{pkg}.buildDate=#{time.iso8601}
      -X #{pkg}.gitCommit=#{tap.user}
      -X #{pkg}.semVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "."

    generate_completions_from_executable(bin/"falcoctl", "completion")
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_path_exists testpath/"ca.crt"
    assert_path_exists testpath/"client.crt"

    assert_match version.to_s, shell_output("#{bin}/falcoctl version")
  end
end
