class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/refs/tags/v3.0.16.tar.gz"
  sha256 "a3977f96d80cae64b37d439f6d40691cf70be013019a7363736530a613f8cbcc"
  license "Unlicense"
  head "https://github.com/simonwhitaker/gibo.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a67d83a8d370d32de6f47fa97210e972c0949caaf232cd98a15fe3a1e4249318"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a67d83a8d370d32de6f47fa97210e972c0949caaf232cd98a15fe3a1e4249318"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a67d83a8d370d32de6f47fa97210e972c0949caaf232cd98a15fe3a1e4249318"
    sha256 cellar: :any_skip_relocation, sonoma:        "f14c1c1fe00324fc685cc4f17e70891aad5bd2f3853f5b1eff5d90e2c9c74935"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ca9b9ae7f8c4c0a15a67756b37b45e94fa35a3fa5329238bde15d9d45eb4da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "875cae4046adca98f41f232a963e59b59d05c4140267f08472d74c5cf9dde56c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gibo", shell_parameter_format: :cobra)
  end

  test do
    system bin/"gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
