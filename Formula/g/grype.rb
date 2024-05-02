class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.77.2.tar.gz"
  sha256 "d48040b1aaae323c08e54fbd8dae86f5925cd17616ed68c066a57083d9776ba4"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8ae60628d1212b362ed833824b77d68e7ec8828d39ddab9440e330dedb90a12"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db8eb8fde49a59c8c7c7b1a81b71048b761340c0f0176119870a802e549c53b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da58adb221a6ece1a8f860a9ec3516716e3aa4b1bf3bf9765364cbcdf349eba0"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4d91f819e57932f0a5c843ed6ff6b36f9024823b5e69992bbe41f21f4ddf4ab"
    sha256 cellar: :any_skip_relocation, ventura:        "e1791b54fcba813cd6045f4b4244979cd2869cb595bf6fc4baaf21ca19bcb60d"
    sha256 cellar: :any_skip_relocation, monterey:       "f8f41493046393e28abd0570031252e7b821a4a610fd52bc6b49b8b93c7fc663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a2ffc0253705c98eccc2dd76cdc2f787a1440d514f82dd27060392dce79cf69"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
