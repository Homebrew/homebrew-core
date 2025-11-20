class Cloudfox < Formula
  desc "Automating situational awareness for cloud penetration tests"
  homepage "https://github.com/BishopFox/cloudfox"
  url "https://github.com/BishopFox/cloudfox/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "7ed3113aea2b057223bb1d224548ce83f16ed0934691af5981ae6dfa6166795b"
  license "MIT"
  head "https://github.com/BishopFox/cloudfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "201030be96bf3a072eba58a3ec197eb5a939fe672af1b5ee37a27156d1037778"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c459c773fb676c576e07f18b588508ff09bc36def968828c3cd056cb8bc7db1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c459c773fb676c576e07f18b588508ff09bc36def968828c3cd056cb8bc7db1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c459c773fb676c576e07f18b588508ff09bc36def968828c3cd056cb8bc7db1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f0eccb09e0f8c082b4e721ac1d8b05716f9e9fb1c375c943bff2094d783d870"
    sha256 cellar: :any_skip_relocation, ventura:       "2f0eccb09e0f8c082b4e721ac1d8b05716f9e9fb1c375c943bff2094d783d870"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d1032c5ab9a1f795dccbc308d6e1caa6bdb984e611755ede2ad44dca0595b4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5964869f0ce17839b73d033bc3ea5909b135b9a8e2d1a5b13bcac7d61177d2c3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin/"cloudfox", "completion")
  end

  test do
    ENV["AWS_ACCESS_KEY_ID"] = "test"
    ENV["AWS_SECRET_ACCESS_KEY"] = "test"

    output = shell_output("#{bin}/cloudfox aws principals 2>&1")
    assert_match "Could not get caller's identity", output

    assert_match version.to_s, shell_output("#{bin}/cloudfox --version")
  end
end
