class Clamav < Formula
  desc "Anti-virus software"
  homepage "https://www.clamav.net/"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/Cisco-Talos/clamav.git", branch: "main"

  stable do
    url "https://github.com/Cisco-Talos/clamav/releases/download/clamav-1.5.4/clamav-1.5.4.tar.gz"
    mirror "https://www.clamav.net/downloads/production/clamav-1.5.4.tar.gz"
    sha256 "1af1117a228f1b5bc7fa91a0dabc37848a99e7d25188e9be8043332ce721dfd3"

    # Backport support for OpenSSL 4
    patch do
      url "https://github.com/Cisco-Talos/clamav/commit/0097a6f99d9f6b78381e12b677a38fb62242c41a.patch?full_index=1"
      sha256 "3d8d697e3d1b369836b2a3b2a4d618de682330b5c804ae655ae36a16d28f7403"
      type :backport
      resolves "https://github.com/Cisco-Talos/clamav/pull/1731"
    end

    # TODO: Remove when a ClamAV release includes PR #1774's digest provider lifetime fix.
    # Preserve digest provider lifetimes, upstream PR ref, https://github.com/Cisco-Talos/clamav/pull/1774
    patch do
      url "https://github.com/Cisco-Talos/clamav/commit/729eaef96263970dede0808426374bb0597dae90.patch?full_index=1"
      sha256 "af4a67eacad5d0fbf8d60c85e10737a2eea35f2eecb6df63584168950ff13ecb"
      type :unofficial
      resolves "https://github.com/Cisco-Talos/clamav/pull/1774"
    end

    # TODO: Remove when a ClamAV release includes PR #1774's digest regression coverage.
    # Cover digest lifetime and thread safety, upstream PR ref, https://github.com/Cisco-Talos/clamav/pull/1774
    patch do
      url "https://github.com/Cisco-Talos/clamav/commit/c905f7e2fbe6d75dab3061b3fdada62aef229217.patch?full_index=1"
      sha256 "fb31f2fa6671cbab01ba61f4a89715bf48e57a9c418bd5ce26e845fcbb43f5ab"
      type :unofficial
      resolves "https://github.com/Cisco-Talos/clamav/pull/1774"
    end

    # TODO: Remove when a ClamAV release includes PR #1774's cache ownership and error handling.
    # Preserve cache ownership and error semantics, upstream PR ref, https://github.com/Cisco-Talos/clamav/pull/1774
    patch do
      url "https://github.com/Cisco-Talos/clamav/commit/b823aef0635f6f8a1cd35e1ef603b8a07472c6f7.patch?full_index=1"
      sha256 "77a22d793f5c291836f3ec64ecb3518b09e55c5ad8bf65ec213614a39e9f8345"
      type :unofficial
      resolves "https://github.com/Cisco-Talos/clamav/pull/1774"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "f15dc7848979650c7d832302f7db93bede76f4233f0c69152e25237ec92cd74a"
    sha256 arm64_tahoe:       "61b43dc3270c1cadd015362c439a3ecbb0010f7305af7dfa955abdc219a34e21"
    sha256 arm64_sequoia:     "e54a977af9228f0ae606ae7f4fc63a74ad7cdb16460c0c39a4d25e650bb25776"
    sha256 arm64_linux:       "62e6ca7aa9dfa48fcd8557a0f0b2af2d4be5859e2f014c1848f9f21ed60c6123"
    sha256 x86_64_linux:      "20cbe6d4910039057858b3be2ff2c59beb7d3cc778ba6f6e44a4ea2fa231c29e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "json-c"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "yara"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  skip_clean "share/clamav"

  allow_network_access! :test

  def install
    args = %W[
      -DAPP_CONFIG_DIRECTORY=#{pkgetc}
      -DDATABASE_DIRECTORY=#{var}/lib/clamav
      -DENABLE_JSON_SHARED=ON
      -DENABLE_STATIC_LIB=ON
      -DENABLE_SHARED_LIB=ON
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DENABLE_MILTER=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (var/"lib/clamav").mkpath
  end

  service do
    run [opt_sbin/"clamd", "--foreground"]
    keep_alive true
    require_root true
  end

  def caveats
    <<~EOS
      To finish installation & run clamav you will need to edit
      the example conf files at #{pkgetc}/
    EOS
  end

  test do
    (testpath/"freshclam.conf").write <<~EOS
      DNSDatabaseInfo current.cvd.clamav.net
      DatabaseMirror database.clamav.net
    EOS

    system bin/"freshclam", "--datadir=#{testpath}", "--config-file=#{testpath}/freshclam.conf"
    system bin/"clamscan", "--database=#{testpath}", testpath
  end
end
