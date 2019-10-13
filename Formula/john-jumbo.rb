class JohnJumbo < Formula
  desc "Enhanced version of john, a UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://openwall.com/john/k/john-1.9.0-jumbo-1.tar.xz"
  version "1.9.0"
  sha256 "f5d123f82983c53d8cc598e174394b074be7a77756f5fb5ed8515918c81e7f3b"

  bottle do
    rebuild 1
    sha256 "e7a19321df5d635dab8f7049d96ee032c7536f1f2bf41b2b1d032e1665bfd127" => :catalina
    sha256 "51f7b265d83da1db5c2a34e77d2f376e1fa7730ecde5c9cfcda181ccab084f8e" => :mojave
    sha256 "0719a701b7280ccd2bd1e2f834ffb6518d183f80c5df2afcb956f374e6d032c3" => :high_sierra
    sha256 "6349fe1f1c0524382ab6ed36a4ceeb795c67cacb310688e2759cf33efab82609" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "openssl@1.1"

  conflicts_with "john", :because => "both install the same binaries"

  # https://github.com/magnumripper/JohnTheRipper/blob/bleeding-jumbo/doc/INSTALL#L133-L143
  fails_with :gcc do
    cause "Upstream have a hacky workaround for supporting gcc that we can't use."
  end

  # Fixed setup `-mno-sse4.1` for some machines.
  # See details for example from here: https://github.com/magnumripper/JohnTheRipper/pull/4100
  patch do
    url "https://github.com/magnumripper/JohnTheRipper/commit/a537bbca37c1c2452ffcfccea6d2366447ec05c2.diff?full_index=1"
    sha256 "c246b7a4b06436810dee66d324fa550c5f6bc2dabcb09a2f5f7836c6633a549a"
  end

  # Fixed setup of openssl@1.1 over series of patches
  # See details for example from here: https://github.com/magnumripper/JohnTheRipper/pull/4101
  patch do
    url "https://github.com/magnumripper/JohnTheRipper/pull/4101.diff?full_index=1"
    sha256 "c21ba72b1267752c8fe70b6f48baf6a36bf4f4796a58e5b2f5998a3a42f96126"
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
    (testpath/"test").write "dave:#{`printf secret | /usr/bin/openssl md5`}"
    assert_match(/secret/, shell_output("#{bin}/john --pot=#{testpath}/john2.pot --format=raw-md5 test"))
    assert_match(/secret/, (testpath/"john2.pot").read)
  end
end
