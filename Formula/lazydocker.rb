class Lazydocker < Formula
  desc "Lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      tag:      "v0.19.0",
      revision: "26858c31545b06f9c1ade37cab6e35e1d6611fde"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b4f06e52669bc14b355f17d1162153f0050eb345875f125d7cad94c51f2a6c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62f63cf4af66dbc975bf19e8ec2d0c843d46f47af43d9a44112d03e4b737fc34"
    sha256 cellar: :any_skip_relocation, monterey:       "092a34510d68c69562c552eefccce8e18dc11014af7ec5013290648e13a0d63b"
    sha256 cellar: :any_skip_relocation, big_sur:        "95d8955955340b3e813df4e9e4f2a36da41f59faa4c5faa3454491dc2c09dca9"
    sha256 cellar: :any_skip_relocation, catalina:       "5bb04acefeaad1af30ff2065f9c4bd9168d7ef30349d47bf8deca34b940ea458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88380083c486996f2fd3e15767abc9514a564cf0bcfa61698b005eb915c750e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "language: auto", shell_output("#{bin}/lazydocker --config")
  end
end
