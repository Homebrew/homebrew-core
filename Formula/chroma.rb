class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "98a517ae99f48e3b54d5c8cd7473d5c544f51bee7a4be17f5175736fce37da56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d760ced5f31db4e69703ba2fddff9cd69273ec31981531691704701fb6bbe55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c1f528c2f1e7f6f9f677578cd0922d2a891d2545be5450db684212ca4ba18f7"
    sha256 cellar: :any_skip_relocation, monterey:       "2cc922fe4835d6b493ac83257a40abe3ce8ebfb8b0b849ddb8a16189e659be32"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fb90ee11ea3f5fd3c19c8bca3aba69cc988c5e8a3cb606223e25444fa66b984"
    sha256 cellar: :any_skip_relocation, catalina:       "35f46598926c60c2b90ce54ff2e91b1a6ef52548fa6402f58ea46dba11731152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4514c41955707aefd692278cef659e252324170bcf0c61a4e9e324aca20d1a31"
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
