class Chkbit < Formula
  desc "Check your files for data corruption"
  homepage "https://github.com/laktak/chkbit"
  url "https://github.com/laktak/chkbit/archive/refs/tags/v6.5.0.tar.gz"
  sha256 "c1ec3df9885c18fbd5746ee64c371c06210908c7f6f33816f2249a09382b46e1"
  license "MIT"
  head "https://github.com/laktak/chkbit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ff0e2506eb1569a45176b1938513958dc811b6c2a9ef28b9133d197c2e812c0b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff0e2506eb1569a45176b1938513958dc811b6c2a9ef28b9133d197c2e812c0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff0e2506eb1569a45176b1938513958dc811b6c2a9ef28b9133d197c2e812c0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "f568b25f86e3842a96442768c476490160642cdf5673a4bbd2c11b4cc2d4a84c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f29b9baaa482b1f598348a28ba90758f34ab1ead57f7ab2d07d97ee38d3e9d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e3b4852c4e043f8aa33e0fe5eaebab33d10761eb833d639ff8c9d1e8f9f938b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/chkbit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chkbit version").chomp
    system bin/"chkbit", "init", "split", testpath
    assert_path_exists testpath/".chkbit"
  end
end
