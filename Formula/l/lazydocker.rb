class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.21.1",
      revision: "c635266fae82f9c41456053cb5cee19280b40b9b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea180350e59542577deda3720b3fa39049828490b2f6d1e5a33ea2cf57c77a2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea180350e59542577deda3720b3fa39049828490b2f6d1e5a33ea2cf57c77a2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea180350e59542577deda3720b3fa39049828490b2f6d1e5a33ea2cf57c77a2d"
    sha256 cellar: :any_skip_relocation, ventura:        "07b6a0f1f3670a51e1345d67b5f080209f686435c1ac17f95a9137d35307f54a"
    sha256 cellar: :any_skip_relocation, monterey:       "07b6a0f1f3670a51e1345d67b5f080209f686435c1ac17f95a9137d35307f54a"
    sha256 cellar: :any_skip_relocation, big_sur:        "07b6a0f1f3670a51e1345d67b5f080209f686435c1ac17f95a9137d35307f54a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0492e10f9b2e0ccecb5b556ed39968122f9c74b9fd0f711f228ae410e598db3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
