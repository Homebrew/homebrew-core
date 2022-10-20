class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "dbbca1194990203049e6e0c95b2e8242a61e2be1d37261ae9168f0c02a309935"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45c05688ed39c64f93bc3b8e72483047da54de75c368c057cd670e48b9ddc0b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dfca2198b7160d94283337fe6e27fd6fe10d657a81b1f4c8535e64d45c07720"
    sha256 cellar: :any_skip_relocation, monterey:       "c221ee1fa14e2b2f66e600b191d8ac0e7e355002fa31fda61135447d91f3bf13"
    sha256 cellar: :any_skip_relocation, big_sur:        "4926641c71a67efebc0a5a754f0278ccc98c06a57ae3d80ac3d3333c1209a7ee"
    sha256 cellar: :any_skip_relocation, catalina:       "f970f18bfeb3880158276a0c2a28e5e6a2a0fd68ace3dd2e3cc9efebe8c2dfa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10fd6cc73258a0325c6849e053caaa635793d770cdfeec4a381ecde800ed8e25"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system "#{bin}/git-workspace", "add", "github", "foo"
    assert_match "provider = \"github\"", File.read("workspace.toml")
    output = shell_output("#{bin}/git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github user\/org foo", output
  end
end
