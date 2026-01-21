class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "d190b5449a2b14108db1409a09dd78b6ae3adc1647632584a9f5ff2aae24ff66"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22fd94ebbf5c5023a9314ef79e4bba16ed8bc927578bf18944afe1ae4cdb999e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3536372b5673df55b32b0adf72816e52bf815176b03e317a850074b890fbb2c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b29e840be3351651bc0c9dcd7b6db21c84fa2291d7069b18c8104d1eaf22ed5"
    sha256 cellar: :any_skip_relocation, sonoma:        "c33609764449d0780f0309e2eba5ed97871391efe2aee7f0f37b637f50ecda10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4608b82d262f9c13ac02e67e7e5c2588da1ec8fd179276e6b5166218028f78b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e55b6c8fa0811c8772c819e53c3ada9265ad83504b6541e0a5f144a56a64ce20"
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

    generate_completions_from_executable(bin/"falcoctl", shell_parameter_format: :cobra)
  end

  test do
    system bin/"falcoctl", "tls", "install"
    assert_path_exists testpath/"ca.crt"
    assert_path_exists testpath/"client.crt"

    assert_match version.to_s, shell_output("#{bin}/falcoctl version")
  end
end
