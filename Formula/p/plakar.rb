class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "f8a2e04366e383a69f1077fb0a3607a44418ab98da13fa4718a79ec633dd975c"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05bfe0625daf8826181764459e8ba36f86d02227ff06467690c152f95e145667"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "818e741785d9ca4725d714652740c4131c89beab5f34505b939e5d475df9e092"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7284fbb3ee7b602f5d9165e3ffc9985d35951794453e59484e895b19ba9c09b"
    sha256 cellar: :any_skip_relocation, sonoma:        "31c706033abcc1c17a781556c587efba6a71d7123c115a40667a9ecbbee8cc4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee546b3ea5d384ad040ddbeed9dcc559c12d751eba775428bda076030ea7404a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "601a6eb18db4e0fa7b509056e7a5a774eee4db3db44af7beff75914815b4aa5e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    system bin/"plakar", "-no-agent", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo
    assert_match "Repository", shell_output("#{bin}/plakar -no-agent at #{repo} info")
  end
end
