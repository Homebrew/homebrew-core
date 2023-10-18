class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "5f63d50fb2fb4c66cdfef10afcf3b7d4d3fa72e3474006a579ae58b1df7b772e"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7be3f8b96c14b9d2c19a5f41e27f2cb95f24b49adc38d9c26b5659e6f31ed41a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70d216febeadf6fef05e89a6e8eccc79b0adbb4811282db25848b1d8ee7ce110"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e28336a5f2a0e75185d8dadac842324d7119e221ca77badd4089fdc1b9ab73d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c69a468c6a7062f2dd1a119e5e5763786be9895a0f163948621bd043bb0d02e"
    sha256 cellar: :any_skip_relocation, ventura:        "3e3f87cd13c46d7b032933bc715a40f3d599a1c2cf4be341471d623098ab60ca"
    sha256 cellar: :any_skip_relocation, monterey:       "ddae8ac16f8cef5c2b10b367c78956f01aa6da669664e1f0bd8db793951c0a30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bc6300acf12592aedb4f710716270edf96d28e74cb8b50e53caf2888de80427"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
