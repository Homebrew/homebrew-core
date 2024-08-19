class Pivit < Formula
  desc "Sign and verify data using hardware (Yubikey) backed x509 certificates (PIV)"
  homepage "https://github.com/cashapp/pivit"
  url "https://github.com/cashapp/pivit/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "1c4500d79d0e3940ed6014fbe49fce187076e3a5c4a6f48d35c1e32a0fa8a196"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e6e3a50973cff8bbd3b13b3843bfea1ec2ed15fd3efd9f0067d0fd7a13e5bb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ab84e8cd028a353a7c3a1d56f2f21091af6a3d45f871f72060e1d392f81fb29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "109c97db1df845a019040e66b43e87b15149e289e1eb51fc1f1dff987d375f00"
    sha256 cellar: :any_skip_relocation, sonoma:         "5ec03a2500ced0b1f789dedaac0b497ad236d61466c9540cc00bf4098f47df60"
    sha256 cellar: :any_skip_relocation, ventura:        "8432aee4d843e56b325e7150b72eccd0c2a74173454560a231a978b3aee4ebf9"
    sha256 cellar: :any_skip_relocation, monterey:       "8de77578a95e5c05a901dc2d646b9fb581d6f000c5176598fbac1fe4ee674a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "334d2fbc85f65f8ad540236503aaf44ace0fe0b3ad9289c828bd212642d6caee"
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
