class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.13.3.tar.gz"
  sha256 "f5930c1536417c6bf51ebfa5ce81bb7048bb67a373b80dbd4a5d497daff5e5a6"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6ee66f3883c786fe36edaded8beb4d16c96692851201ecffbfee20b9f0297eab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fd197d5d728c2155c57774f64b3298d27159eab7924fc6bdd2f1761dbbf5d19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f62da9b882a7b60ce3fc5a55ff7c2c6534c9baaf2fa342cc3ae2b779cc751895"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be946fb092b3156572893296fe3461337ef8e2a7b2ceb56aba70817dc064dd97"
    sha256 cellar: :any_skip_relocation, sonoma:         "4dfabb0df83c907fff10cae849c68a661148f3927b28a17bfef707655730af2b"
    sha256 cellar: :any_skip_relocation, ventura:        "4a1d53fd965a3964bb07605a6c0afd809738c0d3fcc25b9d663866ac3c92478f"
    sha256 cellar: :any_skip_relocation, monterey:       "fc1479263e985d8eb7e84361c5f4fd3d4139c1ae8ab9e70d67a56ff28adc64ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "92cad37a2016130d3bfe93e9a82da321967f8f0f58b60249c85e8b943edc8f02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d82a76d9d0de142a59fe6aa96fb56876552e2f8e7b634f295fa2b702b4f700d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", "completion")
  end

  test do
    ENV.delete "AWS_REGION"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "MissingRegion", output

    ENV["AWS_REGION"] = "us-west-2"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "NoCredentialProviders", output
  end
end
