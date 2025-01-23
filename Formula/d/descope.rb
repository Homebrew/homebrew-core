class Descope < Formula
  desc "Command-line utility for performing common tasks on Descope projects"
  homepage "https://www.descope.com"
  url "https://github.com/descope/descopecli/archive/refs/tags/v0.8.11.tar.gz"
  sha256 "fa5460f3c96ca0596b2bfe72bd20cd689bd5adad3b6603c23533565de9210f18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bb4ae8bb4c29c8f185d060ac3750ee3116da5df67cd11a4a9667570ee325349"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bb4ae8bb4c29c8f185d060ac3750ee3116da5df67cd11a4a9667570ee325349"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bb4ae8bb4c29c8f185d060ac3750ee3116da5df67cd11a4a9667570ee325349"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ac7654197187d0184db64d24514ea7656c4c325e9544f9eae77ba89722a05db"
    sha256 cellar: :any_skip_relocation, ventura:       "8ac7654197187d0184db64d24514ea7656c4c325e9544f9eae77ba89722a05db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f61d3bb6de69dac1d3ee6ece1e8251ae41c56cc85688ea2a8bdb9325f7f44e61"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"descope", "completion")
  end

  test do
    assert_match "working with audit logs", shell_output("#{bin}/descope audit")
    assert_match "managing projects", shell_output("#{bin}/descope project")
    assert_match version.to_s, shell_output("#{bin}/descope --version")
  end
end
