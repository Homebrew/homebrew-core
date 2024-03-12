class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.13.0.tar.gz"
  sha256 "f3538d9db5df0d0325f3eaab7e3d465a6ec9ad6067051863ac52241f070824a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "175db47fe2849d76fcc58899ee5ce1e1e9a3077ee624868f8a69ca8b8ef0305d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "175db47fe2849d76fcc58899ee5ce1e1e9a3077ee624868f8a69ca8b8ef0305d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "175db47fe2849d76fcc58899ee5ce1e1e9a3077ee624868f8a69ca8b8ef0305d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ac8f4678dce62bc85192b9f7e1ad9bc544eae55dc196aae06a47e9ceca10273"
    sha256 cellar: :any_skip_relocation, ventura:        "7ac8f4678dce62bc85192b9f7e1ad9bc544eae55dc196aae06a47e9ceca10273"
    sha256 cellar: :any_skip_relocation, monterey:       "7ac8f4678dce62bc85192b9f7e1ad9bc544eae55dc196aae06a47e9ceca10273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "906f60101b92ff9bce032b3583119f5afcf95e63e5a694291584354845d0bce4"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
