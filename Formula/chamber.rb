class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.6.tar.gz"
  sha256 "b5b667fefe54cf2d1805e7e1cd1676d7e2817678500031aaa0cd5efdd4f3b130"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bcd5c6bcffa145e80b1ec6106bdee181a50afa4763f63914ccf21b733d5f29a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84b69b46b76eb37177043d1c7a2f1598925005dcae822f1b1dd637b137d6b3a7"
    sha256 cellar: :any_skip_relocation, monterey:       "cb1602300084ca2528dccb7531fd97e39af887300c481cbf9cf41774aa9c5cb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "28ad359ee59635c5d42578ff307055c4061212bf04dcb6479deab92f4ce73b9c"
    sha256 cellar: :any_skip_relocation, catalina:       "4d313ab693ce9f1b73c4a40bbacb2478bcf4892894911a8d2ba3aa5ff63597f0"
    sha256 cellar: :any_skip_relocation, mojave:         "abbead2f61e23e7c35cf602d03c43f49d4b263e727ece4caae342d524226b2e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a02bfda5b5783f3a42bc8ebcf069c4b2d536a320a969bdd4216b41fce1af5204"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=v#{version}", "-trimpath", "-o", bin/"chamber"
    prefix.install_metafiles
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
