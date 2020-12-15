class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.8.tar.gz"
  sha256 "8d8a7b87ce7a260d1cb57034ea66bdb81ebbde3a00667e1ff83eb2bddc07806c"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d50fb2de6328778be4d657415d06132b0c465b8b6249bc5f490fa1e6860d5bb" => :big_sur
    sha256 "9d353a1d31c81486498c357c664441cbb3a2fa9c7d129819b926215ccf5448ce" => :catalina
    sha256 "e20a2edaa279d798d97578eabd40572563c115ecfc02f415f5c6746717086722" => :mojave
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
