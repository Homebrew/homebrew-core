class JohnJumbo < Formula
  desc "Enhanced version of john, a UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://openwall.com/john/k/john-1.9.0-jumbo-1.tar.xz"
  version "1.9.0"
  sha256 "f5d123f82983c53d8cc598e174394b074be7a77756f5fb5ed8515918c81e7f3b"
  license "GPL-2.0"

  livecheck do
    url "https://github.com/magnumripper/JohnTheRipper.git"
    regex(/^v?(\d+(?:\.\d+)+)-jumbo-\d$/i)
  end

  bottle do
    rebuild 1
    sha256 "95093dfbf970ea88a41223a1c75c6152e8435795f01f1be812439d28f94378e2" => :big_sur
    sha256 "e7a19321df5d635dab8f7049d96ee032c7536f1f2bf41b2b1d032e1665bfd127" => :catalina
    sha256 "51f7b265d83da1db5c2a34e77d2f376e1fa7730ecde5c9cfcda181ccab084f8e" => :mojave
    sha256 "0719a701b7280ccd2bd1e2f834ffb6518d183f80c5df2afcb956f374e6d032c3" => :high_sierra
    sha256 "6349fe1f1c0524382ab6ed36a4ceeb795c67cacb310688e2759cf33efab82609" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "openssl@1.1"

  conflicts_with "john", because: "both install the same binaries"

  # https://github.com/magnumripper/JohnTheRipper/blob/bleeding-jumbo/doc/INSTALL#L133-L143
  fails_with :gcc do
    cause "Upstream have a hacky workaround for supporting gcc that we can't use."
  end

  # Fixed setup `-mno-sse4.1` for some machines.
  # See details for example from here: https://github.com/magnumripper/JohnTheRipper/pull/4100
  patch do
    url "https://github.com/magnumripper/JohnTheRipper/commit/a537bbca37c1c2452ffcfccea6d2366447ec05c2.patch?full_index=1"
    sha256 "bb6cfff297f1223dd1177a515657b8f1f780c55f790e5b6e6518bb2cb0986b7b"
  end

  # Fixed setup of openssl@1.1 over series of patches
  # See details for example from here: https://github.com/magnumripper/JohnTheRipper/pull/4101
  patch do
    url "https://github.com/magnumripper/JohnTheRipper/commit/4844c79bf43dbdbb6ae3717001173355b3de5517.patch?full_index=1"
    sha256 "8469b8eb1d880365121491d45421d132b634983fdcaf4028df8ae8b9085c98ae"
  end
  patch do
    url "https://github.com/magnumripper/JohnTheRipper/commit/26750d4cff0e650f836974dc3c9c4d446f3f8d0e.patch?full_index=1"
    sha256 "43d259266b6b986a0a3daff484cfb90214ca7f57cd4703175e3ff95d48ddd3e2"
  end
  patch do
    url "https://github.com/magnumripper/JohnTheRipper/commit/f03412b789d905b1a8d50f5f4b76d158b01c81c1.patch?full_index=1"
    sha256 "65a4aacc22f82004e102607c03149395e81c7b6104715e5b90b4bbc016e5e0f7"
  end

  def install
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE=1"
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE_EXEC='\"#{share}/john\"'"
    ENV.append "CFLAGS", "-DJOHN_SYSTEMWIDE_HOME='\"#{share}/john\"'"

    ENV.append "CFLAGS", "-mno-sse4.1" unless MacOS.version.requires_sse4?

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
