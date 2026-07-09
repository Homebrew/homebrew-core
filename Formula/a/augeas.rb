class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  license "LGPL-2.1-or-later"
  revision 2

  stable do
    url "https://github.com/hercules-team/augeas/releases/download/release-1.14.1/augeas-1.14.1.tar.gz"
    sha256 "368bfdd782e4b9c7163baadd621359c82b162734864b667051ff6bcb57b9edff"

    # Fixes `implicit-function-declaration` error
    # Remove when merged and released
    patch do
      url "https://github.com/hercules-team/augeas/commit/26d297825000dd2cdc45d0fa6bf68dcc14b08d7d.patch?full_index=1"
      sha256 "6bed3c3201eabb1849cbc729d42e33a3692069a06d298ce3f4a8bce7cdbf9f0e"
    end

    # Backport fix for CVE-2025-2588
    patch do
      url "https://github.com/hercules-team/augeas/commit/af2aa88ab37fc48167d8c5e43b1770a4ba2ff403.patch?full_index=1"
      sha256 "74edfe9248644c88eb0ed78d4f7f677ff00284ed4cef563779238caf3a7aa139"
    end
  end

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "2892b23195b7b47069e656f53c2421e7d7a72b2bf52e155e88bb2deebdb5aaeb"
    sha256 arm64_sequoia: "bce63494ef71096631916e4dc8c8ba4f38de70df2ab997a448db5143e7b16615"
    sha256 arm64_sonoma:  "8d377f15f9e15f40c3ca6b3de2afbdeeb808c08dfa9a89903a8b36c0f0bc2b23"
    sha256 sonoma:        "460c292b7c6a2e2a3f4bb98b468830a491792e82c92f8f688124903674d7f92c"
    sha256 arm64_linux:   "5ce934dec1d8de104c5347895c95f02c5f0965145474cdef866dd9a512c497ab"
    sha256 x86_64_linux:  "ba562790d6783f698cb827068f53004f5fa2c72e61217c378b5f83ff7f4cc1d9"
  end

  head do
    url "https://github.com/hercules-team/augeas.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "libxml2"

  def install
    ENV.append "LDFLAGS", "-L#{formula_opt_lib("readline")}"

    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      Lenses have been installed to:
        #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/augtool --version 2>&1")

    (testpath/"etc/hosts").write <<~EOS
      192.168.0.1 brew.sh test
    EOS

    expected_augtool_output = <<~EOS
      /files/etc/hosts/1
      /files/etc/hosts/1/ipaddr = "192.168.0.1"
      /files/etc/hosts/1/canonical = "brew.sh"
      /files/etc/hosts/1/alias = "test"
    EOS
    assert_equal expected_augtool_output,
                 shell_output("#{bin}/augtool --root #{testpath} 'print /files/etc/hosts/1'")

    expected_augprint_output = <<~EOS
      setm /augeas/load/*[incl='/etc/hosts' and label() != 'hosts']/excl '/etc/hosts'
      transform hosts incl /etc/hosts
      load-file /etc/hosts
      set /files/etc/hosts/seq::*[ipaddr='192.168.0.1']/ipaddr '192.168.0.1'
      set /files/etc/hosts/seq::*[ipaddr='192.168.0.1']/canonical 'brew.sh'
      set /files/etc/hosts/seq::*[ipaddr='192.168.0.1']/alias 'test'
    EOS
    assert_equal expected_augprint_output,
                 shell_output("#{bin}/augprint --lens=hosts --target=/etc/hosts #{testpath}/etc/hosts")
  end
end
