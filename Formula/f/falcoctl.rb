class Falcoctl < Formula
  desc "CLI tool for working with Falco and its ecosystem components"
  homepage "https://github.com/falcosecurity/falcoctl"
  url "https://github.com/falcosecurity/falcoctl/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "05290a97ac6ac886fc4b34d157d533de37d5a1031f81cf4e6eb1f056c4015f49"
  license "Apache-2.0"
  head "https://github.com/falcosecurity/falcoctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "580f5b4448b45dbce6b0c81469ab2aa5fff60527bfba560e32aba21c4398065c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "975a8845bcb5401fe6b9b8084512ce4ec1f800ca8ea4eb56fce4c1c9cde5c962"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fd72eb17b4b6f5d6839d42f7c4dedc96d3fc0b525a56fda6e8de0169d27757d"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ffd3c24f261628ce5cd34e8e3ed7eb5f1400bfb6c6ef403ee20346b27e94d97"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "166745727c43a2c13dc11acbda8317b4eef4d2603a944dfe5aeee949bcc0792d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a77803385d65096c0b0cad6fbf99aa6b78f47b00c501378e506921893cd7cbe1"
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
