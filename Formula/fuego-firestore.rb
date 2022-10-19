class FuegoFirestore < Formula
  desc "Command-line client for the Firestore database"
  homepage "https://github.com/sgarciac/fuego"
  url "https://github.com/sgarciac/fuego/archive/refs/tags/0.33.0.tar.gz"
  sha256 "25281f2242fe41b0533255a0d4f0450b1f3f8622d1585f8ae8cda1b116ca75d0"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43d3593e573723181fe4da638d570f0034f8c2519a9ac77bfd2602458c7218e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcf5919c53141d78d342055f54b41adf50241ae267e00d348ad15c824458e921"
    sha256 cellar: :any_skip_relocation, monterey:       "1477fe001d7cfe97a6b8088e653850586530fbb7b1c927756521e2a57d36d866"
    sha256 cellar: :any_skip_relocation, big_sur:        "990b84e1a29ef178ec6f7461e85f766057dffd3f9ee6f7676cb5f55fc5171d71"
    sha256 cellar: :any_skip_relocation, catalina:       "c12a445ad59d1afc8e25a8df0111ad2d46b31aa3ea496a1278f988b56e0a45f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a8f43c1327e2d9c89db3dc544c0f9cbb7f5fd123635b992897d9acb356a65cd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"fuego", ldflags: "-s -w")
  end

  test do
    collections_output = shell_output("#{bin}/fuego collections 2>&1", 80)
    assert_match "Failed to create client.", collections_output
  end
end
