class Notify < Formula
  desc "Stream the output of any CLI and publish it to a variety of supported platforms"
  homepage "https://github.com/projectdiscovery/notify"
  url "https://github.com/projectdiscovery/notify/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "9fa8428b4e88da754c265b50a4ea61ee534857ad722c6d6c562362bb238ba1ed"
  license "MIT"
  head "https://github.com/projectdiscovery/notify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02b142fb57ed54d71f187613c85ad84cbf1f10469135ef22fdbf4b180f3dd50d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02b142fb57ed54d71f187613c85ad84cbf1f10469135ef22fdbf4b180f3dd50d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02b142fb57ed54d71f187613c85ad84cbf1f10469135ef22fdbf4b180f3dd50d"
    sha256 cellar: :any_skip_relocation, ventura:        "31938d58bcffd12a2ce69e0c4b81664c18d82101e58c4d455f773046315b12e3"
    sha256 cellar: :any_skip_relocation, monterey:       "31938d58bcffd12a2ce69e0c4b81664c18d82101e58c4d455f773046315b12e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "31938d58bcffd12a2ce69e0c4b81664c18d82101e58c4d455f773046315b12e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0298dea5d5b239adafda958b128ec7f78f4cd23d56c41b4dad2082f1f5a7b226"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/notify"
  end

  test do
    assert_match "Current Version: #{version}", shell_output("#{bin}/notify --version 2>&1")
    assert_predicate testpath/".config/notify/config.yaml", :exist?
  end
end
