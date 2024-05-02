class Mubeng < Formula
  desc "Incredibly fast proxy checker & IP rotator with ease"
  homepage "https://github.com/kitabisa/mubeng"
  url "https://github.com/kitabisa/mubeng/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "27842f0d587ced3b79b3c5e68be7e59272b0f2e89f754e3322d17bf7eda6802c"
  license "Apache-2.0"
  head "https://github.com/kitabisa/mubeng.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe8510b61b0d7ae47875541d8c85fe16920c96653ffc328347f40c3587a94aa9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7caf666e7fc45ec393e1ed8dd0e83fa9b9e7201ce5bcbf1aa46655186826fcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9099041232d8f366521c64e9879a27ef7f9674819835e5ae3c1f542e5b5dcd4"
    sha256 cellar: :any_skip_relocation, sonoma:         "eeaed2f4c1eae8504113a1289d803e0ab0afca59a830b46b9ef216e489a5bcd4"
    sha256 cellar: :any_skip_relocation, ventura:        "8085999ee0889b9dd2c55e5df8a88566bfbea1c647824436177cb35dafa97af1"
    sha256 cellar: :any_skip_relocation, monterey:       "7b07bb39a9369c433d92a5a3f2a7301ea64e9b050627d9d597066706f49c8820"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9989341a971db95ddad349dd0f5239e0f471bed40e5f32b4cb08fb5d8ea4e82b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X ktbs.dev/mubeng/common.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/mubeng"
  end

  test do
    output = shell_output("#{bin}/mubeng 2>&1", 1)
    assert_match "no proxy file provided", output

    assert_match version.to_s, shell_output("#{bin}/mubeng --version", 1)
  end
end
