class Pit < Formula
  desc "Project manager from hell (integrates with Git)"
  homepage "https://github.com/michaeldv/pit"
  license "BSD-2-Clause"
  head "https://github.com/michaeldv/pit.git", branch: "master"

  # upstream commit to allow PREFIX-ed installs
  stable do
    url "https://github.com/michaeldv/pit/archive/refs/tags/0.1.0.tar.gz"
    sha256 "ddf78b2734c6dd3967ce215291c3f2e48030e0f3033b568eb080a22f041c7a0e"

    patch do
      url "https://github.com/michaeldv/pit/commit/f64978d6c2628e1d4897696997b551f6b186d4bc.patch?full_index=1"
      sha256 "f97a553bc5ca0eddf379e3ca3f96374508f8627e18aaff846786c41d7ba1987b"
    end

    # upstream commit to fix a segfault when using absolute paths
    patch do
      url "https://github.com/michaeldv/pit/commit/e378582f4d04760d1195675ab034aac5d7908d8d.patch?full_index=1"
      sha256 "73651472d98aa02e58fbf6f1cc4ce29100616d6f6d155907c4680eb73217f43f"
    end

    # upstream commit to return 0 on success instead of 1
    patch do
      url "https://github.com/michaeldv/pit/commit/5d81148349cc442d81cc98779a4678f03f59df67.patch?full_index=1"
      sha256 "3ae9004fe9551ab51be44df2195bf5e373e1473a888c11601de0d046322d382f"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f777c3a9a9df0126578d3bfcac99340c9de06de98f9a81af90a5e0f1c11a2dfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1c47710f90f70ca700d78780d7a9ecca7edb1c00d131c5b35eca39d22ca50b20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4bb4f8b9fcc6c163347d862d0886d998600259a914148dbb56bd1ef720fa96ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bab334d334f9076b84f008dffa276886491a4567dcce911bca2de19f0a4d462e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdb46ba810ed638aa93d076788bbc3a21f0d563aa5175fdccdae7b9c3476608c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d3857a0cf9c47d2d53f87109d87a4823fed481398cf2adb6c9f3809b8085985"
    sha256 cellar: :any_skip_relocation, sonoma:         "c58c911d92fce75efe1c60827d6a3d55df5eb063e579d60e4272883a17bc9b33"
    sha256 cellar: :any_skip_relocation, ventura:        "43d88cf92d08f7169764740b0dcf55d529ad3e88e5297d8eede1b9cbcbca2849"
    sha256 cellar: :any_skip_relocation, monterey:       "cea94d460905b3f03d850b3e15a99d9a2e1d18558be52a8740dfbae36d7b27e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "853489d4ee4f37e97f89415f5a3d1e0c225cb2dace8f61680293bb61ad57dd52"
    sha256 cellar: :any_skip_relocation, catalina:       "3ff5098a860de65a101fafe58d9ef76ac4c392f0b127720ecb34f0141554c27d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cb9c8ae7f2445d94adf1d721988c9c03e4501ce200d9b82ddb6e278befe533d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9d22e313984a6d20930041fd3cbb5896826e0be8a687992866ceef0e79152c7"
  end

  uses_from_macos "ruby"

  def install
    ENV.deparallelize
    bin.mkpath

    system "make"
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"pit", "init"
  end
end
