class Goclone < Formula
  desc "Website Cloner"
  homepage "https://github.com/goclone-dev/goclone"
  url "https://github.com/goclone-dev/goclone/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "1e005a045b3d2f5d4d0a7154f4552e537900c170256b668cc73aeac204d9defa"
  license "MIT"
  head "https://github.com/goclone-dev/goclone.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "427643691179069c7834cf098036b07742eb8e17ee9de1ba024f022b59791a41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "427643691179069c7834cf098036b07742eb8e17ee9de1ba024f022b59791a41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "427643691179069c7834cf098036b07742eb8e17ee9de1ba024f022b59791a41"
    sha256 cellar: :any_skip_relocation, sonoma:        "63b7e1660bea0cfec0e9998e5c5d10c4d4283461ab39eeb023240eac4f2f25c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5840964691bed030e57c2e1530696170715d3982bbce48c2fec28c7250f317db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "181e8771f7509e520cb7c6c88d9f8edc56e8c5eb5623a8aff286b2059fbe94b1"
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

    generate_completions_from_executable(bin/"goclone", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goclone version")

    system bin/"goclone", "https://example.com"
    assert_path_exists testpath/"example.com"
  end
end
