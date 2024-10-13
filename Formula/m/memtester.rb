class Memtester < Formula
  desc "Utility for testing the memory subsystem"
  homepage "https://pyropus.ca/software/memtester/"
  url "https://pyropus.ca/software/memtester/old-versions/memtester-4.6.0.tar.gz", using: :homebrew_curl
  sha256 "c9fe4eb7e80c8cef5202f9065c4c0682f5616647c0455e916a5700f98e3dbb2e"
  license "GPL-2.0-only"

  # Despite the name, all the versions are seemingly found on this page. If this
  # doesn't end up being true over time, we can check the homepage instead.
  livecheck do
    url "https://pyropus.ca/software/memtester/old-versions/"
    regex(/href=.*?memtester[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e8935eb4d3637ccd62b0bd75f35a5fda4f0fc8354b965b65a8a53dd91cea6e0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "66e03622f2496abd25d5554da03f3f3805fc88ac41e44d749299b4372b81e4b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41a41ca665729fff67552a31fb300107c07c5cd455b28eefbccbd72639f74fd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b540c6a252e4eb89b36bfbbce41ec3bfd01d907cf8a7bb3f60992c248e8dcad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0d1f6ca41a92356b1730a6a18cb1504742a5c00570d5ae6f5c964bc356776e8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b8816e0cb4a85f592967c8fdf754fd8ef9598fbfb035bee03aceed4c6205add"
    sha256 cellar: :any_skip_relocation, ventura:        "99e25743f80404ddc89cf53826be6f286533ac63c9c5824c55ceffd01a89fca3"
    sha256 cellar: :any_skip_relocation, monterey:       "be7d9dda10e0514edb563d68bbe0243de866f21d43e4cd6bec8c0bf3f0d0c78e"
    sha256 cellar: :any_skip_relocation, big_sur:        "77696db97be5d12bc7e1fda39b1877d874c2a22abc8d623fbf8a5633564b9118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55598380121620207e07c7806304cdd0282e3d52b78b2945b3eaea8292fa23fd"
  end

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "INSTALLPATH", prefix
      s.gsub! "man/man8", "share/man/man8"
    end
    inreplace "conf-ld", " -s", ""
    system "make", "install"
  end

  test do
    system bin/"memtester", "1", "1"
  end
end
