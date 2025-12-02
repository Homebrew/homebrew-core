class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "https://augeas.net/"
  license "LGPL-2.1-or-later"
  revision 1

  stable do
    url "https://github.com/hercules-team/augeas/releases/download/release-1.14.1/augeas-1.14.1.tar.gz"
    sha256 "368bfdd782e4b9c7163baadd621359c82b162734864b667051ff6bcb57b9edff"

    # Fixes `implicit-function-declaration` error
    # Remove when merged and released
    patch do
      url "https://github.com/hercules-team/augeas/commit/26d297825000dd2cdc45d0fa6bf68dcc14b08d7d.patch?full_index=1"
      sha256 "6bed3c3201eabb1849cbc729d42e33a3692069a06d298ce3f4a8bce7cdbf9f0e"
    end
  end

  livecheck do
    url :stable
    regex(/\D*?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "a08a4025060f11bc910787a5d6b162574eade8ff34e7356993a350ddb1e8513e"
    sha256 arm64_sequoia: "61ecffdbb3274cba9dadd7dd5ec7228ee5f295657770e51bdd373e10c218649e"
    sha256 arm64_sonoma:  "0a7c0baf3f14c5d22153f4305a6e0a5bed461ea772531e9a241c730e404b49d4"
    sha256 sonoma:        "c1783548eb059f6683082c9bafa82feb42e14db5f6898fb226491ab280f37cdd"
    sha256 arm64_linux:   "df6d3bc86b8c810bd1f1584d6487e119dcf4815e64460ce66785ee6c8e040993"
    sha256 x86_64_linux:  "1cc2e3a0712c76dd52bf5d15b7c816464539de6d400f6a12e30f8474eda0d87e"
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
    ENV.append "LDFLAGS", "-L#{Formula["readline"].opt_lib}"

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
