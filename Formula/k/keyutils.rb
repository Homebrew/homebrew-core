class Keyutils < Formula
  desc "Linux key management utilities"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/snapshot/keyutils-1.6.3.tar.gz"
  sha256 "a61d5706136ae4c05bd48f86186bcfdbd88dd8bd5107e3e195c924cfc1b39bb4"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "569fc190618bdad81896e66145fe832b1d858644d19c87a59ce417158e0cea7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d5b06c4e38d2c4b7decb5b7bc0431b3416993231e5fa688950e4df83686a298d"
  end

  depends_on :linux

  def install
    inreplace "request-key.conf" do |s|
      s.gsub! %r{(\s)/bin/key}, "\\1#{opt_bin}/key"
      s.gsub! %r{(\s)/sbin/key}, "\\1#{opt_sbin}/key"
      s.gsub! %r{(\s)/usr/share/#{name}/}, "\\1#{opt_pkgshare}/"
    end

    args = %W[
      BINDIR=#{bin}
      ETCDIR=#{etc}
      INCLUDEDIR=#{include}
      LIBDIR=#{lib}
      MANDIR=#{man}
      SBINDIR=#{sbin}
      SHAREDIR=#{pkgshare}
      USRLIBDIR=#{lib}
    ]
    system "make", "install", *args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/keyctl --version")
    system bin/"keyctl", "supports"

    # CI container doesn't have permissions to modify keys/keyrings
    return if ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.sh").write <<~SHELL
      keyring=$(#{bin}/keyctl new_session)
      key=$(#{bin}/keyctl add user home brew "$keyring")
      #{bin}/keyctl print "$key"
    SHELL
    assert_equal "brew\n", shell_output("bash -e test.sh")
  end
end
