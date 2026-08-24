class PvMigrate < Formula
  desc "CLI tool to migrate or backup/restore Kubernetes persistent volumes"
  homepage "https://github.com/utkuozdemir/pv-migrate"
  url "https://github.com/utkuozdemir/pv-migrate/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "23c6811740ccb3135151e3083bd5500f336161d0a70e76c68d8b9f87d85d071a"
  license "Apache-2.0"
  head "https://github.com/utkuozdemir/pv-migrate.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55c3d79c5a9509500a026881fa7831b504a76e4e86dc8d63af15357255a3b18a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d01a496c826654a60c5f36010a6158a5f25d23044a45d0f1d13aaeb08eec6b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cab18802024f8e1c3d712a3fbd604e36f2a163bfdff6fd471bcc0d85575f3a80"
    sha256 cellar: :any_skip_relocation, sonoma:        "5457806424819d2917c9184d0c8ed4d5dbb2fa9e058caa554f58fa5648e42044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3230c226e6cc274dc8ab5454c4ee5c38eb219f7755ee29d7fd78157a6bfa9204"
    sha256 cellar: :any,                 x86_64_linux:  "d50dbc844a427cb87406f578461376fb803ccfa1c6ffdb2512fcb073693e236d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pv-migrate"

    generate_completions_from_executable(bin/"pv-migrate", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pv-migrate --version")
    output = shell_output("#{bin}/pv-migrate migrate 2>&1", 1)
    assert_match "source", output.downcase
  end
end
