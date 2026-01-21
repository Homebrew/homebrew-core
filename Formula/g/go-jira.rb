class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/go-jira/jira"
  url "https://github.com/go-jira/jira/archive/refs/tags/v1.0.27.tar.gz"
  sha256 "c5bcf7b61300b67a8f4e42ab60e462204130c352050e8551b1c23ab2ecafefc7"
  license "Apache-2.0"
  head "https://github.com/go-jira/jira.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "379b37138dec50af1a721ea979bc968474ff2f5dd901e853516836fbe205b456"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "71657b7b31e15f29675a246bb6a900dd5ae8d7156bbfe7aea9c2f07f460da220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "887196c990be21bd4cf00789fb18849eac19a704e2b4962a4de933aec8da9dc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f733c561a610de82fdabf831fa5dccd2d94cbdd128338d83afbe46ff432e2fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e59a1ae3dc441cf2216b2aab847239884fadaa77b78c56b2d005ef2dd37a7519"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1352079509d72281e76344ebe41a0704b97a0c116151fb7536a2bb6b26d2bf1"
    sha256 cellar: :any_skip_relocation, sonoma:         "609f2bfd921e78ecb37ebed62ac71ce480c8a6713c1525950c42ab56cac6cfee"
    sha256 cellar: :any_skip_relocation, ventura:        "6abb3ebbda9a8a58d0cd89d9bdacf4e35bc0086acc951568454ca63ad5ff0c02"
    sha256 cellar: :any_skip_relocation, monterey:       "7e5fd3b74f5866d42899c6fb895c95b72465db1eb6a41be127e644c12cdf0f53"
    sha256 cellar: :any_skip_relocation, big_sur:        "40fd5a4ecfcb1f7a296651f59f28829e760a1ef69f884766b5262abf972663d6"
    sha256 cellar: :any_skip_relocation, catalina:       "82a05966c4af4b6200507909bc37eaef905f96d69d1c790ae655e35741ca058c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "138271ad126a983ec28561e6a57cc82755e3efd4eed795612cece818a482c42e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6892ea2385e3c1eb948612c8a9c98a14442ccbdb046779fb0948db892112dc74"
  end

  depends_on "go" => :build

  conflicts_with "jira-cli", because: "both install `jira` binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"jira"), "cmd/jira/main.go"
  end

  test do
    system bin/"jira", "export-templates"
    template_dir = testpath/".jira.d/templates/"

    files = Dir.entries(template_dir)
    # not an exhaustive list, see https://github.com/go-jira/jira/blob/4d74554300fa7e5e660cc935a92e89f8b71012ea/jiracli/templates.go#L239
    expected_templates = %w[comment components create edit issuetypes list view worklog debug]

    assert_equal([], expected_templates - files)
    assert_equal("{{ . | toJson}}\n", File.read("#{template_dir}/debug"))
  end
end
