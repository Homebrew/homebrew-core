class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.73.5.tar.gz"
  sha256 "3161118a835d849388a4024f76423adcc1ad8c491713dc83327d36ff9ce2e34b"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ece4c34611f2b214f48072d4c0e828820ae11b89d2eab4078935a3e354245ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46ad114397a92e9700636180c519a12d6f5b93e1cd958a2193ecb490d7d38c02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f260c3415074a8d5428df59c80c8084d4ebbc8f79192c7d092906dcaf25fb7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "70f4bac61577508b0a35de2a3a178dcd6c50290d2049fa938019aaddd958e892"
    sha256 cellar: :any_skip_relocation, ventura:        "456bbb6b48b3bff52c724c86b25e9148adbc9d02d943d14d41e9b9957ee5e0e0"
    sha256 cellar: :any_skip_relocation, monterey:       "e8c2ef6ea8b5a696b8c3e8782ba83366a1e089a7311bbc6b99b0e3315632e4b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f96713be675d9c7bdfa43ed023f5e1ee6e03f88c91b35d6f8a85792672727508"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end
