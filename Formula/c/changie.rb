class Changie < Formula
  desc "Automated changelog tool for preparing releases"
  homepage "https://changie.dev/"
  url "https://github.com/miniscruff/changie/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "6d33ceff946315c5bab7f8d91b558cfbd022fd52d5179edc51949611fa7b3668"
  license "MIT"
  head "https://github.com/miniscruff/changie.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5b554334ab7ed1e5f5ab7f36b1be65817c3083361807b414ac301924ae3c960"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "885e974b67936b6dd803c304b776d4e15012b1241ad02fc39851a3e8b6064d80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2e200bef10febcc8719d1e912fbde7fad194bec71700c5706b0895b91de3605"
    sha256 cellar: :any_skip_relocation, sonoma:         "00df79368edd0350eb491e9c7467466665587b986fb1ef166517915211bc5f24"
    sha256 cellar: :any_skip_relocation, ventura:        "5a2b96633b6781cb6c0f27a39bc32ff527a57d6a4889d799956fa3df87f5af65"
    sha256 cellar: :any_skip_relocation, monterey:       "72466739c5dec741865b103ab6d5ceae9e1a26b7e37b0479ea682092f5daa14a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ad531fa421382b53f187ea4ae586a8053eb826a9042301cebb26a56486b9c3d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"changie", "completion")
  end

  test do
    system bin/"changie", "init"
    assert_match "All notable changes to this project", (testpath/"CHANGELOG.md").read

    assert_match version.to_s, shell_output("#{bin}/changie --version")
  end
end
