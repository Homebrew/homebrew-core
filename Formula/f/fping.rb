class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-5.5.tar.gz"
  sha256 "15c4e32b6c55ff105bafe03e8c91c7ca1b2eda31bf9a7127326bb87887ee18fe"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?fping[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8e132e94c41b8dcf3149faf3356beece440bc4f5b804e723e9f7ee9cb14817d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbe25f1d45b4b018ed308fd986f26211a00cf32c205ebc5c46ebcafdc546e352"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "251479f09a0b2ef3cf58fcd6a7144d0b33baf68f1555f2a6dcdcfea4b1e3eaef"
    sha256 cellar: :any_skip_relocation, sonoma:        "f126c58d92896bc945c83969b8ee25e7ec5aee3b2480eb836f6c036a550f7c54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7df0fdc7745faf467a98549da150873dc5c944cf5a3deb49c64972d5a0eda5b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cc39f11322e6922333f12d26b85a755520ff205f4214b9602bb7062d79b7673"
  end

  head do
    url "https://github.com/schweikert/fping.git", branch: "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--sbindir=#{bin}"
    system "make", "install"
  end

  test do
    assert_match "Version #{version}", shell_output("#{bin}/fping --version")
    assert_match "Probing options:", shell_output("#{bin}/fping --help")
    assert_equal "127.0.0.1 is alive", shell_output("#{bin}/fping -4 -A localhost").chomp
  end
end
