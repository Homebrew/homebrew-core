class Mujs < Formula
  desc "Embeddable Javascript interpreter"
  homepage "https://www.mujs.com/"
  url "https://mujs.com/downloads/mujs-1.3.7.tar.gz"
  sha256 "fa15735edc4b3d27675d954b5703e36a158f19cfa4f265aa5388cd33aede1c70"
  license "ISC"
  head "https://github.com/ccxvii/mujs.git", branch: "master"

  livecheck do
    url "https://mujs.com/downloads/"
    regex(/href=.*?mujs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "52b7e1468b1d7b7a493f953fe52be4e91c8fc00223b97b9512b9aa8d787514cd"
    sha256 cellar: :any,                 arm64_sonoma:  "daf4da3709624eed9c6b5de2d6eaf53c0b3638fdb1be06f8bface0332bca81b9"
    sha256 cellar: :any,                 arm64_ventura: "e5d5e280103b96ae1c4424b778d6bc04b5fd5930ea7e779ca728b0c0913c9953"
    sha256 cellar: :any,                 sonoma:        "650c453369a790c299d2a18d48e26180c500fc45dff44c096542e3cdd54c735d"
    sha256 cellar: :any,                 ventura:       "96dc1e1d6885f3668149484766172f053ae14ceff5edcf3ec25dc7c78b33b207"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10dcbc661f36958c88762bfaaa5ccbc3597d4a26a251a966129a7ed6a781dc4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08acc6ab105fbb7517a610c2abdaf8439bda9059fb98673f1a825b67c8385092"
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
