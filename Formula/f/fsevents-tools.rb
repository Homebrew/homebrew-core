class FseventsTools < Formula
  desc "Command-line utilities for the FSEvents API"
  homepage "https://geoff.greer.fm/fsevents/"
  url "https://geoff.greer.fm/fsevents/releases/fsevents-tools-1.0.0.tar.gz"
  sha256 "498528e1794fa2b0cf920bd96abaf7ced15df31c104d1a3650e06fa3f95ec628"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?fsevents-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "e9c957de83e07813d6363e58bf6d8e1c9ade1592ce6a965817d57a0b824fd165"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "69d137adc9cbcce94aa7160b76705454f3f04fc0598f2146264887fc0a278c2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "665d116f18811af91513b9cd670e8504cc765bebc6e114fbf815930bd48386f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "862af188ba8ede21f7810c642424284d257e2ffdb88ae8652d0eff0ce519d270"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4485f966db472e54a07bc973d25945a4b72e110e68222bbd6ffb206bef843d74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "613a2ee6e962c3681f00a36382fe87089c92a235d2db0dec7e8fb8e74f993b0e"
    sha256 cellar: :any_skip_relocation, sonoma:         "367075f9a0a7b7c725905609d2fa4c5808a43a468a24c791ccf09ec75672d4b1"
    sha256 cellar: :any_skip_relocation, ventura:        "3136f299634d309fd98b7aaec18e4b03b28b4c61716b86e8a32f3933f0bba669"
    sha256 cellar: :any_skip_relocation, monterey:       "1d2134afbb595faece7c4025d78a7f0de8c52e3c90ff8c6965aa645526fb867a"
    sha256 cellar: :any_skip_relocation, big_sur:        "da9e4eed81589e2ea9e7f6a9186cd178ad965d5cba6b71ed2a3515729cd1cfb7"
    sha256 cellar: :any_skip_relocation, catalina:       "a59b40a61a49089e4a3ba5bbf0bd51790f043975c51c05c8eec39bf54425ae2e"
  end

  head do
    url "https://github.com/ggreer/fsevents-tools.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "pkgconf" => :build
  end

  depends_on :macos

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    fork do
      sleep 2
      touch "testfile"
    end
    assert_match "notifying", shell_output("#{bin}/notifywait testfile")
  end
end
