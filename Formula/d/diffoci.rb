class Diffoci < Formula
  desc "Diff for Docker and OCI container images"
  homepage "https://github.com/reproducible-containers/diffoci"
  url "https://github.com/reproducible-containers/diffoci/archive/refs/tags/v0.1.8.tar.gz"
  sha256 "05fd59d8c6bb5d960077638a3e68725093b73c4ca9f2f2fe2da1f696020ee5d4"
  license "Apache-2.0"
  head "https://github.com/reproducible-containers/diffoci.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a82a319d9dd41da78de7ebf39679728d6bf717464633090e8b40a40b41424fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a82a319d9dd41da78de7ebf39679728d6bf717464633090e8b40a40b41424fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a82a319d9dd41da78de7ebf39679728d6bf717464633090e8b40a40b41424fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba83691299b16adcf8e966b390a19a3d1bae6725076975ff3cec4625a096aa26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bf9d32792a3fbd7f79727910c36b5ee35f7a79ae404e174fdfbaa67faae6c5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ccb44913fb72336ba70b383eb58dadb313688ad7e4b92a3384a830cd5c4121"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/reproducible-containers/diffoci/cmd/diffoci/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/diffoci"

    generate_completions_from_executable(bin/"diffoci", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Backend: local", shell_output("#{bin}/diffoci info")

    assert_match version.to_s, shell_output("#{bin}/diffoci --version")
  end
end
