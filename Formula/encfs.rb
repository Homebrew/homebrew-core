class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.5.tar.gz"
  sha256 "4709f05395ccbad6c0a5b40a4619d60aafe3473b1a79bafb3aa700b1f756fd63"
  # The code comprising the EncFS library (libencfs) is licensed under the LGPL.
  # The main programs (encfs, encfsctl, etc) are licensed under the GPL.
  license "GPL-3.0"
  revision 3
  head "https://github.com/vgough/encfs.git"

  bottle do
    sha256 catalina:     "c41dd4f6c6eae27645695e7540a6e1ec25cd4a15756e5f5ed97a345cd39372fc"
    sha256 mojave:       "1cc308274ff04d95ab12bc39be227517dbf264e5cf811d72b153d6f84b06c0cb"
    sha256 high_sierra:  "137944ecee75c5d82634bf1458316c4d64d841ed9f92a4638ad266503f92b66f"
    sha256 sierra:       "79e5d3548036ae74ed956bea6d9c4ab7f2e12faf7b49b541da9a72476159a557"
    sha256 x86_64_linux: "2c8863fccfcdb4e42cca450763879b7238b5a506a9385b25c3a3c3e2bf27c69d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    ENV.cxx11

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end
