class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.12.tar.gz"
  sha256 "832e819b4fd7440ee12b3dc4bc45364956f3bad9280c8eb0062acb8a43ce9efd"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff066b253794e6a3142f48618a14369215c89cd8a47b4f66953ff175d916309e" => :big_sur
    sha256 "b8267ea6000ac543927b55a6ff96293d89152bbd2362eea12172c15b1ffbfc08" => :catalina
    sha256 "288d04dce5159fef32c396a41158a3793851c8c1c42cd266b70b4faa8a58cac7" => :mojave
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
