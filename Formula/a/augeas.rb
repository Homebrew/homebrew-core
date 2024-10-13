class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  url "https://github.com/hercules-team/augeas/releases/download/release-1.14.1/augeas-1.14.1.tar.gz"
  sha256 "368bfdd782e4b9c7163baadd621359c82b162734864b667051ff6bcb57b9edff"
  license "LGPL-2.1-or-later"
  head "https://github.com/hercules-team/augeas.git", branch: "master"

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia:  "235513308423f52fd6d049cf16b5e0c31b0862bce0d8aa6afb11ce2e8208020a"
    sha256 arm64_sonoma:   "72892294927f45da15836ea628404d5ea93597344d93dfe1ba3889dc9c1daf68"
    sha256 arm64_ventura:  "9d42d73d125f3aa9e859ecf4e0029b9e0e4a9354b166d7d7d96e4753bf99348c"
    sha256 arm64_monterey: "6ce2ccf218f4ac51eae364b50a74eae014820ddb0e2073700da3e8b3b58735e3"
    sha256 sonoma:         "8a2fe89ec726bcc30aeb669014f3a22dee5f5d649cd35f32839fb41f01ac1e10"
    sha256 ventura:        "9ecddaf5c923d43477fcd22de3949bf85bdadd5c69c424af840e7e636ecd47de"
    sha256 monterey:       "39ec06ee5c541c591d89ed0770a9b6de354f4df19413217d70eecf272e4662b2"
    sha256 x86_64_linux:   "b42ec1edf00ea7a66acff5ea7286a68b5bbbfa49442a3ab818f8c6c13eafdb32"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "libxml2"

  # Fixes `implicit-function-declaration` error
  # Remove when merged and released
  patch do
    url "https://github.com/hercules-team/augeas/commit/26d297825000dd2cdc45d0fa6bf68dcc14b08d7d.patch?full_index=1"
    sha256 "6bed3c3201eabb1849cbc729d42e33a3692069a06d298ce3f4a8bce7cdbf9f0e"
  end

  def install
    if build.head?
      system "./autogen.sh", *std_configure_args
    else
      system "./configure", *std_configure_args
    end

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
