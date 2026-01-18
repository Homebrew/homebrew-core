class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.56.3.tar.gz"
  sha256 "bf807dd91a3e2194de26da1c42842e7ba55bcd0be5a33f4a8f46a2f283a5aa86"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3861053cce97f67bca1454d0f0152f8a0e60427cb666f819fab58b9dcddf0de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3861053cce97f67bca1454d0f0152f8a0e60427cb666f819fab58b9dcddf0de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3861053cce97f67bca1454d0f0152f8a0e60427cb666f819fab58b9dcddf0de"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e74c7ce056df289297de15e2832eba9f87d81fa05b0e1fcfcf558a4b0a24a7f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53906665ea36cacaa1fc701d794803929b29bcb93dc1d925d17428299ba034fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6d2c4d50f50df4d8939c52c1f1c42feac43bf06a50ebdbae1f93d9f41a41e73"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
