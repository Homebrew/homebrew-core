class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://github.com/ibara/mg"
  url "https://github.com/ibara/mg/releases/download/mg-7.3/mg-7.3.tar.gz"
  sha256 "1fd52feed9a96b93ef16c28ec4ff6cb25af85542ec949867bffaddee203d1e95"
  license all_of: [:public_domain, "ISC", "BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause"]
  version_scheme 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "8be28a3fd77e3ae1a7a94dc2f2effed298f61b92528075c748535ff78a542eab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "14c363b5eeea07b8f117cb74b9676ae6a92dc26a9f1f39d9d9169fda5577a242"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31940ad999d42c596d86df83651fea272faf4da53ec9b69b71b05165ec01d5bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22b26617c6ce69d7c1e5e69a0628aac1db8f60e164c788bb7784841fd02818a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f367179c081b6bd5f234d68d8134466d1d7a7e457b3258053da668e454b087bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1ae7a5e2cc9fcca2bb497a9dc76bd7473b204a2f806edc1db524dd5aba9e5f2"
    sha256 cellar: :any_skip_relocation, sonoma:         "898a96da03a4a7adf3fd3ec361fc457153c43e9e803f9d00fcefed541591b6d3"
    sha256 cellar: :any_skip_relocation, ventura:        "908aaa04c673ffa9db16ac98987b01b6d822a1285f3ab62a0e4d4f0c2d38b919"
    sha256 cellar: :any_skip_relocation, monterey:       "e3190e17138e2c21d7429ff591be1c3d574a7e13a0e1a10457f2e479cc5bf9e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "12e3599c5fe68404690bae22a653cc00915cdf797041be2d67845e4760d41df7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9cc7f3ad4ae912fabafe2f0aaf6cb1624a2d786769a7632ea956bd03c72b8c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df7547e37e627c0504896e045d8c8df6adc3ea3dbdade674b1b964fcf333397f"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    require "pty"
    PTY.spawn({ "TERM" => "xterm" }, bin/"mg", "test") do |r, w, pid|
      sleep 1
      w.write "brew\n\u0018\u0003y"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    ensure
      r.close
      w.close
      Process.wait(pid)
    end
    assert_equal "brew\n", (testpath/"test").read
  end
end
