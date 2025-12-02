class Goclone < Formula
  desc "Website Cloner"
  homepage "https://github.com/goclone-dev/goclone"
  url "https://github.com/goclone-dev/goclone/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "1e005a045b3d2f5d4d0a7154f4552e537900c170256b668cc73aeac204d9defa"
  license "MIT"
  head "https://github.com/goclone-dev/goclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddba84e7b78ba1d593334db9d0ee36d715ad42bebdc312226dea21af4bb6447e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddba84e7b78ba1d593334db9d0ee36d715ad42bebdc312226dea21af4bb6447e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddba84e7b78ba1d593334db9d0ee36d715ad42bebdc312226dea21af4bb6447e"
    sha256 cellar: :any_skip_relocation, sonoma:        "127265db94813530de50e62d876bab9c8c5816d7fd72e403deae3b839b7cb4de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22bcc703a2061363148dcd8d9dde63d3294fdf4545ee8d25d10eae06b4089781"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afb265120ffe469dca64d907742b3f256e0dfb48c3c774b1567d21a66aba255c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=#{tap.user}
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/goclone"

    generate_completions_from_executable(bin/"goclone", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goclone version")

    system bin/"goclone", "https://example.com"
    assert_path_exists testpath/"example.com"
  end
end
