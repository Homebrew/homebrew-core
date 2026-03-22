class Ndenv < Formula
  desc "Node version manager"
  homepage "https://github.com/riywo/ndenv"
  url "https://github.com/riywo/ndenv/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "1a85e4c0c0eee24d709cbc7b5c9d50709bf51cf7fe996a1548797a4079e0b6e4"
  license "MIT"
  head "https://github.com/riywo/ndenv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3aff8712af287caad53964e17c254d5470652fa61c22562579f82b726fc0e977"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8650428e672ef45ea98634ed9e024064c9c23e4604fb7f423fe5d7e12cd13f96"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64537c94265589e52b05cd90de6998880d58960ee25ea3c2d207e92107b6b10d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e3e31b092194e5f29f15cd18ce26de6fa69dc372b05850f86effa058de0c681"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e3e31b092194e5f29f15cd18ce26de6fa69dc372b05850f86effa058de0c681"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d36486433ad28c722a9d0e3b6e780e369beea2855a126c91abae2c1e83384c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "41545d5c9c5db7c5569d5fe4b0925b99716f104714013efc11c5be65dfa908ef"
    sha256 cellar: :any_skip_relocation, ventura:        "0185213be14f5f212bbacc1fe2e6f28c0b2a50ed3adbba1da1b189f4168621ec"
    sha256 cellar: :any_skip_relocation, monterey:       "0185213be14f5f212bbacc1fe2e6f28c0b2a50ed3adbba1da1b189f4168621ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "11134806587add67781fb03d7be2fd2322029e77e4b744d927fba9afbe6e1b82"
    sha256 cellar: :any_skip_relocation, catalina:       "11134806587add67781fb03d7be2fd2322029e77e4b744d927fba9afbe6e1b82"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c5c259e192f7344bd7e565e602495bbdbba873162f5cd149109148730f189e85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50382fe45272fa7f72497bb0f40a02fd4bf9e293eca303777b9e154021f7c501"
  end

  deprecate! date: "2025-08-24", because: :deprecated_upstream, replacement_formula: "nodenv"

  depends_on "node-build"

  def install
    inreplace "libexec/ndenv" do |s|
      if HOMEBREW_PREFIX.to_s != "/usr/local"
        s.gsub! ":/usr/local/etc/ndenv.d",
            ":#{HOMEBREW_PREFIX}/etc/ndenv.d\\0"
      end
    end

    if build.head?
      inreplace "libexec/rbenv---version", /^(version=)"([^"]+)"/,
          %Q(\\1"\\2-g#{Utils.git_short_head}")
    end

    prefix.install "bin", "completions", "libexec"
    system bin/"ndenv", "rehash"
  end

  test do
    shell_output "eval \"$(#{bin}/ndenv init -)\" && ndenv versions"
  end
end
