class Busted < Formula
  desc "Elegant Lua unit testing"
  homepage "https://lunarmodules.github.io/busted/"
  url "https://github.com/lunarmodules/busted/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "befca10f573bb476fa1db2e3149150d65f802a71d34d1682679e640665f2dc2b"
  license "MIT"
  head "https://github.com/lunarmodules/busted.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "86eff6847066324485ec0565d35720a6f5a7802ab571131904e38b0f917055a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dcff5cb71f86dd72db670cc83b1ed19dfde1af3b1efd756cc46ec530a3c1f6fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9267e5bd352ff30b679465035c1a6180df40dabdec7b4e14f31f1857155ebe00"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "005189ce90798040e77012a87a523454c8a64f6dcdf27e2d2022cb5a81c60491"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86a649562e5124e1d9761e1bb18e2589e89a013268fed32dd9c12a1dc7be0f13"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d46925551fc50862907fe770dde0aaf06cad8d476ed7f313988afb3eb23b5a2"
    sha256 cellar: :any_skip_relocation, ventura:        "bec97bc61b1ffe4f39f035d2710c626b6f31c91c1fa16c778fcc0bc3704681b2"
    sha256 cellar: :any_skip_relocation, monterey:       "8510ad64b34d08addb54433deca168f8f7f2c1db6df90c7ab41f32ae352d23a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9296bbdb2e2a16feae4033c598626a68edfbbd3523cb9d71631d640d4da59895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed3b9a4fea656d23198b327ed55879761fd1ab0f5332adf34db382f86622d8d1"
  end

  depends_on "luarocks" => :build
  depends_on "lua"

  uses_from_macos "unzip" => :build

  def install
    system "luarocks", "make", "--tree=#{libexec}", "--local", "--lua-dir=#{Formula["lua"].opt_prefix}"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_file = testpath/"test.lua"

    test_file.write <<~LUA
      describe("brewtest", function()
        it("should pass", function()
          assert.is_true(true)
        end)
      end)
    LUA

    assert_match "1 success / 0 failures", shell_output("#{bin}/busted #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/busted --version")
  end
end
