class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  url "https://mujs.com/downloads/mujs-1.3.8.tar.gz"
  sha256 "506d34882f2620a2fdeb6db63dbb7a8ffd98f417689d8f3c84f2feac275e39a9"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git", branch: "master"

  livecheck do
    url "https://mujs.com/downloads/"
    regex(/href=.*?mujs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "483f0c294f3e9ba954dbb610e69109cc594dafe50b6737a8e6e2417f649771f2"
    sha256 cellar: :any,                 arm64_sequoia: "19d0fb4208c23b02a92f38bdc7b6c645fc292ac71740abe19c525a6d26bdde8f"
    sha256 cellar: :any,                 arm64_sonoma:  "7640010c83e19665d80f35908dd7a5ecd1778a5d9e9e9de4ea2a8c1fe7364ef4"
    sha256 cellar: :any,                 sonoma:        "e909e607b4e27f8328a1e2e589afda4d6b95b9b0e359f8d1734485e0e561c203"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3b5ec6930bb76ffa5f0471c3bc5df3c3a090c1c0cdc442bd8add8f8b02df7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5c42b004f13aaccfd81ad264a9f80401e2f39f454f0f01080c936bf1d7e89af"
  end

  depends_on "pkgconf" => :test

  on_linux do
    depends_on "readline"
  end

  # update build for `utfdata.h`, upstream pr ref, https://github.com/ccxvii/mujs/pull/203
  patch do
    url "https://github.com/ccxvii/mujs/commit/e21c6bfdce374e19800f2455f45828a90fce39da.patch?full_index=1"
    sha256 "e10de8b9c3a62ffe121b61fe60b67ba8faa68eaace9a3b17a13f46a2cc795a11"
  end

  def install
    system "make", "prefix=#{prefix}", "release"
    system "make", "prefix=#{prefix}", "install"
    system "make", "prefix=#{prefix}", "install-shared" if build.stable?
  end

  test do
    (testpath/"test.js").write <<~JAVASCRIPT
      print('hello, world'.split().reduce(function (sum, char) {
        return sum + char.charCodeAt(0);
      }, 0));
    JAVASCRIPT
    assert_equal "104", shell_output("#{bin}/mujs test.js").chomp
    # test pkg-config setup correctly
    assert_match "-I#{include}", shell_output("pkgconf --cflags mujs")
    assert_match "-L#{lib}", shell_output("pkgconf --libs mujs")
    system "pkgconf", "--atleast-version=#{version}", "mujs"
  end
end
