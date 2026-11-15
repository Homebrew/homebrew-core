class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  url "https://mujs.com/downloads/mujs-1.3.11.tar.gz"
  sha256 "456a395769daf110a30f9bf6f793044261e261481d5dca33b63cdc8714774ca4"
  license "ISC"
  compatibility_version 3
  head "https://codeberg.org/ccxvii/mujs.git", branch: "master"

  livecheck do
    url "https://mujs.com/downloads/"
    regex(/href=.*?mujs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d15dfccde9045998d8a69ea2b2152730bd294247c16d89dd5c6dfd24e2d06456"
    sha256 cellar: :any, arm64_tahoe:       "462a216d223d3cf43356216410830a2618ed18dbe8f0149e2dac38a78a5ea75e"
    sha256 cellar: :any, arm64_sequoia:     "aa9870c50c9719b443e085dc8391d133971b66702d69752f1ecb48e71355e640"
    sha256 cellar: :any, arm64_linux:       "fc50211df9a4f49b04c73e31f42f1e4ea151f1783eaf48c1a91f9460fadf699a"
    sha256 cellar: :any, x86_64_linux:      "dc894b17f3a27cb24596ed159807989ef7fd75ecfb9982024d38a8a512728f39"
  end

  depends_on "pkgconf" => :test

  on_linux do
    depends_on "readline"
  end

  # update build for `utfdata.h`
  patch do
    url "https://github.com/ccxvii/mujs/commit/e21c6bfdce374e19800f2455f45828a90fce39da.patch?full_index=1"
    sha256 "e10de8b9c3a62ffe121b61fe60b67ba8faa68eaace9a3b17a13f46a2cc795a11"
    type :unofficial
    resolves "https://github.com/ccxvii/mujs/pull/203"
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
