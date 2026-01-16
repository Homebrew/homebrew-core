class GitTracker < Formula
  desc "Integrate Pivotal Tracker into your Git workflow"
  homepage "https://github.com/stevenharman/git_tracker"
  url "https://github.com/stevenharman/git_tracker/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "ec0a8d6dd056b8ae061d9ada08f1cc2db087e13aaecf4e0d150c1808e0250504"
  license "MIT"
  head "https://github.com/stevenharman/git_tracker.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ad44db1639c5fd8aca9a1722f8d3e2dec30b2c0b83d8ea3991f846943347ec38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "baa816781cb9119b5c9b2b3e6e3bece9ef82758d1998d250db108751fa2b482a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "04a52cb307fbbf99950c64d3c6716473ff8fa8ad45fe06a33af04777bd4b7047"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c25f12523b2b8de0affa72363cd84c3cc3c8947bfea4765fa47382a1b5185b39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c25f12523b2b8de0affa72363cd84c3cc3c8947bfea4765fa47382a1b5185b39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c25f12523b2b8de0affa72363cd84c3cc3c8947bfea4765fa47382a1b5185b39"
    sha256 cellar: :any_skip_relocation, sonoma:         "04a52cb307fbbf99950c64d3c6716473ff8fa8ad45fe06a33af04777bd4b7047"
    sha256 cellar: :any_skip_relocation, ventura:        "c25f12523b2b8de0affa72363cd84c3cc3c8947bfea4765fa47382a1b5185b39"
    sha256 cellar: :any_skip_relocation, monterey:       "c25f12523b2b8de0affa72363cd84c3cc3c8947bfea4765fa47382a1b5185b39"
    sha256 cellar: :any_skip_relocation, big_sur:        "c25f12523b2b8de0affa72363cd84c3cc3c8947bfea4765fa47382a1b5185b39"
    sha256 cellar: :any_skip_relocation, catalina:       "c25f12523b2b8de0affa72363cd84c3cc3c8947bfea4765fa47382a1b5185b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2308338d6721682146bf5d0d960f8606a0061c7e42cf2f1132d33da8ff01201b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaaca7ee99419aa06d95fdbb70c28f435b4f2e596c28124bf80b105c89ffbe9b"
  end

  uses_from_macos "ruby"

  def install
    system "rake", "standalone:install", "prefix=#{prefix}"

    # Replace `ruby` cellar path in shebang
    inreplace bin/"git-tracker", Formula["ruby"].prefix.realpath, Formula["ruby"].opt_prefix unless OS.mac?
  end

  test do
    output = shell_output("#{bin}/git-tracker help")
    assert_match(/git-tracker \d+(\.\d+)* is installed\./, output)
  end
end
