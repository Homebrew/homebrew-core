class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.20.tar.gz"
  sha256 "bd9a6a48e8b20957360a101948be6960aac9b4e28136a3c1d45203f442025d42"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6afcbf830e222e7da395ccf1fb339b81da91afec0d8ffe5a2ac742dad2034f92"
    sha256 cellar: :any_skip_relocation, big_sur:       "936ff0cc40aabaf9f48026bf5be971e4a1ed1f4da62751f7a66ce4db0c60f300"
    sha256 cellar: :any_skip_relocation, catalina:      "6fcc4666cdcdf231ffd70a7a01e6a70bc55e49b6e9c165c19e77226c6c25b938"
    sha256 cellar: :any_skip_relocation, mojave:        "8129c6b4aa22f9732a7ba98eeb903b571fcbc2ca44d0a8adad82cd490e48fbd6"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --help 2>&1")

    output = shell_output("#{bin}/infracost --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
