class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/refs/tags/v2.30.16.tar.gz"
  sha256 "b92d44f37e64115c970c9d6717dd9e9c91830c1689dd0a945ada245854c415ed"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b68af07ef8b6052780a2eb32bacc236b46379ee8bff296953bd8a7c52566778a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73743a1599b4339f012a25da1137ac6bb361753649d58bfb135932da3b991cc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36e2be26bedc129ddc4896cb300ddbe4b6c32b7aa12a226e371c6c82e11f2ebd"
    sha256 cellar: :any_skip_relocation, ventura:        "d63ad93a79864e0bbf3bbc29b4b24501eb7ad3d245b430bd22634ae869be9046"
    sha256 cellar: :any_skip_relocation, monterey:       "19b604548dd4aefa80afe8e9e3e8290736816c9ba6edf208d97d5020ff3ac1a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1b136107109b48a465860c594946770d8f75618359b769abb0a7ff94012cc3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6687c5ccb84e9d74aa1616d97cac7e47af47c2bb1feb4a694abd20906a1df1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/vektra/mockery/v2/pkg/logging.SemVer=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"mockery", "completion")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Starting mockery dry-run=true version=v#{version}", output
  end
end
