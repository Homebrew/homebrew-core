class JohnJumbo < Formula
  desc "Enhanced version of john, a UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://openwall.com/john/k/john-1.9.0-jumbo-1.tar.xz"
  version "1.9.0"
  sha256 "f5d123f82983c53d8cc598e174394b074be7a77756f5fb5ed8515918c81e7f3b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://github.com/openwall/john.git"
    regex(/^v?(\d+(?:\.\d+)+)-jumbo-\d$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "a923ea4c9bba4ae6180d9f173694a5c4dd7ea87e1b84e358bc902695557ef393"
    sha256 arm64_big_sur:  "f4f4d798d0614b6f64ee57f463b94682a483c10010d2953be528f3e16dc2899a"
    sha256 monterey:       "e7b371852f93ca92ae3d6fe93cd161cfff2f5e13991705105ef7237add20864c"
    sha256 big_sur:        "95093dfbf970ea88a41223a1c75c6152e8435795f01f1be812439d28f94378e2"
    sha256 catalina:       "e7a19321df5d635dab8f7049d96ee032c7536f1f2bf41b2b1d032e1665bfd127"
    sha256 mojave:         "51f7b265d83da1db5c2a34e77d2f376e1fa7730ecde5c9cfcda181ccab084f8e"
    sha256 high_sierra:    "0719a701b7280ccd2bd1e2f834ffb6518d183f80c5df2afcb956f374e6d032c3"
    sha256 sierra:         "6349fe1f1c0524382ab6ed36a4ceeb795c67cacb310688e2759cf33efab82609"
    sha256 x86_64_linux:   "7436d7bbfa99d24378592eb1444d05b06d8cf97ada9957aac8f15f1f0512f61e"
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  conflicts_with "john", because: "both install the same binaries"

  # Fixed setup `-mno-sse4.1` for some machines.
  # See details for example from here: https://github.com/openwall/john/pull/4100
  patch do
    url "https://github.com/openwall/john/commit/a537bbca37c1c2452ffcfccea6d2366447ec05c2.patch?full_index=1"
    sha256 "bb6cfff297f1223dd1177a515657b8f1f780c55f790e5b6e6518bb2cb0986b7b"
  end

  # Fixed setup of openssl@1.1 over series of patches
  # See details for example from here: https://github.com/openwall/john/pull/4101
  patch do
    url "https://github.com/openwall/john/commit/4844c79bf43dbdbb6ae3717001173355b3de5517.patch?full_index=1"
    sha256 "8469b8eb1d880365121491d45421d132b634983fdcaf4028df8ae8b9085c98ae"
  end
  patch do
    url "https://github.com/openwall/john/commit/26750d4cff0e650f836974dc3c9c4d446f3f8d0e.patch?full_index=1"
    sha256 "43d259266b6b986a0a3daff484cfb90214ca7f57cd4703175e3ff95d48ddd3e2"
  end
  patch do
    url "https://github.com/openwall/john/commit/f03412b789d905b1a8d50f5f4b76d158b01c81c1.patch?full_index=1"
    sha256 "65a4aacc22f82004e102607c03149395e81c7b6104715e5b90b4bbc016e5e0f7"
  end

  # Upstream M1/ARM64 Support.
  # Combined diff of the following four commits, minus the doc changes
  # that block this formula from using these commits otherwise.
  # https://github.com/openwall/john/commit/d6c87924b85323b82994ce01724d6e458223fd36
  # https://github.com/openwall/john/commit/d531f97180a6e5ae52e21db177727a17a76bd2b4
  # https://github.com/openwall/john/commit/c9825e688d1fb9fdd8942ceb0a6b4457b0f9f9b4
  # https://github.com/openwall/john/commit/716279addd5a0870620fac8a6e944916b2228cc2
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/50a00afbf4549fbc0ffd3855c884f7d045cf4f93/john-jumbo/john_jumbo_m1.diff"
    sha256 "6658f02056fd6d54231d3fdbf84135b32d47c09345fc07c6f861a1feebd00902"
  end

  def install
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE=1"
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE_EXEC='\"#{share}/john\"'"
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE_HOME='\"#{share}/john\"'"

    # Apple's M1 chip has no support for SSE 4.1.
    ENV.append "CFLAGS", "-mno-sse4.1" if Hardware::CPU.intel? && !MacOS.version.requires_sse4?

    ENV["OPENSSL_LIBS"] = "-L#{Formula["openssl@1.1"].opt_lib}"
    ENV["OPENSSL_CFLAGS"] = "-I#{Formula["openssl@1.1"].opt_include}"

    cd "src" do
      system "./configure", "--disable-native-tests"
      system "make", "clean"
      system "make"
    end

    doc.install Dir["doc/*"]

    # Only symlink the main binary into bin
    (share/"john").install Dir["run/*"]
    bin.install_symlink share/"john/john"

    bash_completion.install share/"john/john.bash_completion" => "john.bash"
    zsh_completion.install share/"john/john.zsh_completion" => "_john"
  end

  test do
    touch "john2.pot"
    (testpath/"test").write "dave:#{`printf secret | /usr/bin/openssl md5 -r | cut -d' ' -f1`}"
    assert_match(/secret/, shell_output("#{bin}/john --pot=#{testpath}/john2.pot --format=raw-md5 test"))
    assert_match(/secret/, (testpath/"john2.pot").read)
  end
end
