class JohnJumbo < Formula
  desc "Enhanced version of john, a UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://openwall.com/john/k/john-1.9.0-jumbo-1.tar.xz"
  version "1.9.0"
  sha256 "f5d123f82983c53d8cc598e174394b074be7a77756f5fb5ed8515918c81e7f3b"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://github.com/openwall/john.git"
    regex(/^v?(\d+(?:\.\d+)+)-jumbo-\d$/i)
  end

  bottle do
    rebuild 4
    sha256 arm64_golden_gate: "52199f22fdef94eb0444037d86a80d20f060090a733cbc76c1553ffa56d219b0"
    sha256 arm64_tahoe:       "eb036c2f183b0b8577a2f6708cd79b87e300e11013eba20aba0d33ba9bc73627"
    sha256 arm64_sequoia:     "55a298783b6e1f11f54434c01e5d3c588444b54eb5a360035330cf162d176aa7"
    sha256 arm64_linux:       "5e574793724a9959e8981265d4ebdc69612983f92f8dfe5d3a16784f68ba1198"
    sha256 x86_64_linux:      "e9b0393ffd09a818421a1bdeb275a1162bacc6cf2320a5a5bf301d2acb2cfa98"
  end

  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "openssl@4"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  conflicts_with "john", because: "both install the same binaries"

  # Fixed setup `-mno-sse4.1` for some machines.
  patch do
    url "https://github.com/openwall/john/commit/a537bbca37c1c2452ffcfccea6d2366447ec05c2.patch?full_index=1"
    sha256 "bb6cfff297f1223dd1177a515657b8f1f780c55f790e5b6e6518bb2cb0986b7b"
    type :backport
    resolves "https://github.com/openwall/john/pull/4100"
  end

  # Fixed setup of openssl@1.1 over series of patches
  patch do
    url "https://github.com/openwall/john/commit/4844c79bf43dbdbb6ae3717001173355b3de5517.patch?full_index=1"
    sha256 "8469b8eb1d880365121491d45421d132b634983fdcaf4028df8ae8b9085c98ae"
    type :backport
    resolves "https://github.com/openwall/john/pull/4101"
  end
  patch do
    url "https://github.com/openwall/john/commit/26750d4cff0e650f836974dc3c9c4d446f3f8d0e.patch?full_index=1"
    sha256 "43d259266b6b986a0a3daff484cfb90214ca7f57cd4703175e3ff95d48ddd3e2"
    type :backport
    resolves "https://github.com/openwall/john/pull/4101"
  end
  patch do
    url "https://github.com/openwall/john/commit/f03412b789d905b1a8d50f5f4b76d158b01c81c1.patch?full_index=1"
    sha256 "65a4aacc22f82004e102607c03149395e81c7b6104715e5b90b4bbc016e5e0f7"
    type :backport
    resolves "https://github.com/openwall/john/pull/4101"
  end

  # Upstream M1/ARM64 Support.
  # Combined diff of the following four commits, minus the doc changes
  # that block this formula from using these commits otherwise.
  # https://github.com/openwall/john/commit/d6c87924b85323b82994ce01724d6e458223fd36
  # https://github.com/openwall/john/commit/d531f97180a6e5ae52e21db177727a17a76bd2b4
  # https://github.com/openwall/john/commit/c9825e688d1fb9fdd8942ceb0a6b4457b0f9f9b4
  # https://github.com/openwall/john/commit/716279addd5a0870620fac8a6e944916b2228cc2
  patch do
    file "Patches/john-jumbo/john_jumbo_m1.diff"
  end

  # Fix alignment compile errors on GCC 11. Remove in the next release
  patch do
    url "https://github.com/openwall/john/commit/8152ac071bce1ebc98fac6bed962e90e9b92d8cf.patch?full_index=1"
    sha256 "efb4e3597c47930d63f51efbf18c409f436ea6bd0012a4290b05135a54d7edd4"
    type :backport
    resolves "https://github.com/openwall/john/pull/4611"
  end

  deny_network_access!

  def install
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE=1"
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE_EXEC='\"#{share}/john\"'"
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE_HOME='\"#{share}/john\"'"

    ENV["OPENSSL_LIBS"] = "-L#{formula_opt_lib("openssl@4")}"
    ENV["OPENSSL_CFLAGS"] = "-I#{formula_opt_include("openssl@4")}"

    cd "src" do
      system "./configure", "--disable-native-tests"
      system "make", "clean"
      system "make"
    end

    doc.install Dir["doc/*"]

    # Only symlink the main binary into bin
    (share/"john").install Dir["run/*"]
    bin.install_symlink share/"john/john"

    bash_completion.install share/"john/john.bash_completion" => "john"
    zsh_completion.install share/"john/john.zsh_completion" => "_john"
  end

  test do
    touch "john2.pot"
    (testpath/"test").write "dave:#{`printf secret | /usr/bin/openssl md5 -r | cut -d' ' -f1`}"
    assert_match(/secret/, shell_output("#{bin}/john --pot=#{testpath}/john2.pot --format=raw-md5 test"))
    assert_match(/secret/, (testpath/"john2.pot").read)
  end
end
