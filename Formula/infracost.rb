class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.7.11.tar.gz"
  sha256 "dd1f26cb2e8fb8831f3e774211ece251713f0de612952c499a7f90cdcac945c2"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23e2b89883e79e8945d0e82fd70c8e859561afc3576828e98648465130eb0ca4" => :big_sur
    sha256 "c077c3ba63518d9ddf215ddeaee424dcf05ab4532bddd86843e8d96121b422e8" => :catalina
    sha256 "877bad5a8a4b51b83e335faa5ea3f31e10ca4144b6951f4b378df26b7718762b" => :mojave
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
