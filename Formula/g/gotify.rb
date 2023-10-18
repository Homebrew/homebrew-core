class Gotify < Formula
  desc "Command-line interface for pushing messages to gotify/server"
  homepage "https://github.com/gotify/cli"
  url "https://github.com/gotify/cli/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "9446aa09a675bca2a8fd0448e6c45e28630e31f7578cc9e1587d09f24e59f66a"
  license "MIT"
  head "https://github.com/gotify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7fd505d7e456bca1972d7b793ee81d805ad59ba1b71b148a4d4718860cd9dcff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "089f351450dbfda3a863d43b567bdfee951b403b29a274929431899cd216d2bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "089f351450dbfda3a863d43b567bdfee951b403b29a274929431899cd216d2bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "089f351450dbfda3a863d43b567bdfee951b403b29a274929431899cd216d2bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "53941bf7ef9f64b57d74b2248bda65583f96f42202f59fd951bc6c6ca3b2678f"
    sha256 cellar: :any_skip_relocation, ventura:        "ece8f7f186f1e4116a314969b5615ca03228d1a320edf72eed4075ce133e1540"
    sha256 cellar: :any_skip_relocation, monterey:       "ece8f7f186f1e4116a314969b5615ca03228d1a320edf72eed4075ce133e1540"
    sha256 cellar: :any_skip_relocation, big_sur:        "ece8f7f186f1e4116a314969b5615ca03228d1a320edf72eed4075ce133e1540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "387b4dc3b5651bc315acb0c331a0b2dc9eaf12a0c3aa983c00bbfebf69e03f94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}
                                       -X main.BuildDate=#{time.iso8601}
                                       -X main.Commit=N/A")
  end

  test do
    assert_match "token is not configured, run 'gotify init'",
      shell_output("#{bin}/gotify p test", 1)
  end
end
