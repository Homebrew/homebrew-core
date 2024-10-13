class Blink < Formula
  desc "Tiniest x86-64-linux emulator"
  homepage "https://github.com/jart/blink"
  url "https://github.com/jart/blink/releases/download/1.1.0/blink-1.1.0.tar.gz"
  sha256 "9ac213c7d34a672d2077e79a2aaa85737eb1692d6e533ab2483c07369c60d834"
  license "ISC"
  head "https://github.com/jart/blink.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "94d6d0c9e64d540ada078f6a89d0e9d35936ae9a05f5f98c70d91e2022150de2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2de61fd64e8fbe185bf583189710c8dc8793c13fe5535489638dc4e1116b7901"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed08f66b03fb447aac0c38f232f6d0ddf3d193f11e1ccfda27141e1de452d5b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22ddedacbb9166f752850e36aa9b787c66671f0338a452ea465c6bd8e37885d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfc61d7528246380f32c4926b1345e19064fd62d56e635fce1a49aa7ff8ecdcf"
    sha256 cellar: :any_skip_relocation, ventura:        "5d816c1d15c0eafb78919ce3cf3fe2615835fa35b048ad0925debf212d8e1d82"
    sha256 cellar: :any_skip_relocation, monterey:       "ca2a5adb954404890dfbf93e0bae8934a5568a87e2425068d90e94922eb60bd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b037ea0f7e1afbba04ffcca29bfdc542fa466be4ffacb9015743b720e227750d"
  end

  depends_on "make" => :build # Needs Make 4.0+
  depends_on "pkg-config" => :build
  uses_from_macos "zlib"

  def install
    # newer linker cause issue as `pointer not aligned at _kWhence+0x4`
    # upstream bug report, https://github.com/jart/blink/issues/166
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", "--prefix=#{prefix}", "--enable-vfs"
    # Call `make` as `gmake` to use Homebrew `make`.
    system "gmake" # must be separate steps.
    system "gmake", "install"
  end

  test do
    stable.stage testpath
    ENV["BLINK_PREFIX"] = testpath
    goodhello = "third_party/cosmo/goodhello.elf"
    chmod "+x", goodhello
    system bin/"blink", "-m", goodhello
  end
end
