class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize.git",
      tag:      "v0.25.1",
      revision: "5c3e5e906d9ef8f8b4b7510852f6d08bd410f418"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f51bec7c2cc4764ec9f5bc63255b6ee94468c5df3ca67c9d9e894e3f81ca675"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f51bec7c2cc4764ec9f5bc63255b6ee94468c5df3ca67c9d9e894e3f81ca675"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f51bec7c2cc4764ec9f5bc63255b6ee94468c5df3ca67c9d9e894e3f81ca675"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fb3f024bb1034dc7cb382606ef04008667cfc63db638b8397e5566ef1cc5b7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eadbe23a2d4c00501b95f85559b12779ef91680fdc054b0a81437ae2fbe6da7d"
    sha256 cellar: :any,                 x86_64_linux:  "a1c07e6338e3c758460091855f71fe34c9956c85a62385baf41c6c0f1b814af8"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
