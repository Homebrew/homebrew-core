class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.23.1",
      revision: "1060e17731c80372335446eabe6a56ba4facd2b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4cb37fa117ff2ed6401c4ebcd829f11e3c3eac03ee47f600e26223df001e141e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e0bc6a36e1b65005680c34e97a2f7076d2c59aa0ef8496b4855c1e7e5ecf6ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81b7fd5275849e4d2b2830978cd4a92de59dcf94239f030c3ceda41d4308371a"
    sha256 cellar: :any_skip_relocation, sonoma:         "882b9b927868750845edaab7aee196524589dd821b7e2eb9db9b3d9ffdd18507"
    sha256 cellar: :any_skip_relocation, ventura:        "3de9590c87dcab3d565c03d56bb9cf39f1dd3a9a30374db08ee1ac9ffbe45f13"
    sha256 cellar: :any_skip_relocation, monterey:       "48c4a284a8af8838932d03b0b8341af960f18bb9d6db5fb858cf251ddab80c59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9120342d0e2900fbdac8d02d130c506d6144e75cfe13adbe5d0212d45e4287df"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
