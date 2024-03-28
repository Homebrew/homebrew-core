class Pivit < Formula
  desc "Sign and verify data using hardware (Yubikey) backed x509 certificates (PIV)"
  homepage "https://github.com/cashapp/pivit"
  url "https://github.com/cashapp/pivit/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "aa4668180c6b533fc027cc6e06e09c122edc17a87d4ba87cf9e56a50fef0ebce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9eeea547bd12d775c069be6bb92dcfd2f1d80f62e631aeedb1c56b145ad6b02f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01cc3770325264967e888b5813b49acef716da349dbce54b7ab14ec58f203c63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da11b94d5b336c2b3bcab0f2d9962c3347df5e9c987b8d4f9cb8507fcbd301b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "10839d87733ef335a06d9ce4e652fe7a60c3343dfba22bb0f32c8dd5c4dc91b7"
    sha256 cellar: :any_skip_relocation, ventura:        "04ab2d75412d539b86e27a343be253fae054ce1751aec1d3385e609dbb72583f"
    sha256 cellar: :any_skip_relocation, monterey:       "d831473137e56b2e29db1edf2eade34b993fb43b0f8e7af28821105132ae22dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7891391fcbad7fac0050bf686f365fb5cb1c011ca89a25c63f1daf7b5b08559"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", *std_go_args, "./cmd/pivit"
  end

  test do
    output = shell_output("#{bin}/pivit -p 2>&1", 1).strip
    assert_match "the Smart card resource manager is not running", output
  end
end
