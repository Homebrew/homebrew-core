class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://github.com/rofl0r/proxychains-ng"
  url "https://github.com/rofl0r/proxychains-ng/archive/refs/tags/v4.18.tar.gz"
  sha256 "23000aaeee4702048580d9f4ed46cf1ce07917f6e3b8a08334df48fd74b66453"
  license "GPL-2.0-or-later"
  head "https://github.com/rofl0r/proxychains-ng.git", branch: "master"

  bottle do
    manifest_sha256 "5442716ea910dedaf6f391dd01414ff29917b2029d4425cfa3c5988db92dfc42"
    sha256 arm64_golden_gate: "8aaab6d5705b8a9e82d715c64062db783f3fff78104ec31ed62bb157174e1d58"
    sha256 arm64_tahoe:       "418c5e81d5428eed0a654c7f98b7e125391eb0477ab729a6e6b9138cbb55cc30"
    sha256 arm64_sequoia:     "77c425c2b38228ba4db47361008f8b71ae6277f46cf6a83383741de47babcd7b"
    sha256 arm64_linux:       "0b89613af53f708899ce6dcaf816b216aa24dead5db37fa278d9ade2f1c49a3b"
    sha256 x86_64_linux:      "b66f685da650ff51776df12926e61680b1977142909182dea00ddf4eed416704"
  end

  deny_network_access!

  def install
    system "./configure", *std_configure_args, "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
