class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fwup-home/fwup"
  url "https://github.com/fwup-home/fwup/releases/download/v1.11.0/fwup-1.11.0.tar.gz"
  sha256 "782ed26e25c2e27a416aced1eda7f0cc8ebefe0a73eef01fd8b108b4728104af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "115cdea755621e9587d6534a5184bf21742ae0491202fccbd5e96bcb39dca9b8"
    sha256 cellar: :any,                 arm64_sonoma:  "12db65bb45b7ebf37e617e5125af0dace338e6a5eb82910744e880460cc50b54"
    sha256 cellar: :any,                 arm64_ventura: "d2d2eefd55cd8f4e0a46dfa0df0f2528111cc337f3f25228797a6f09895e69ba"
    sha256 cellar: :any,                 sonoma:        "e2133ddb40c6d7b980711c7f7153dca476a00e32addf28f71ae4f757d0f95d34"
    sha256 cellar: :any,                 ventura:       "68299bb9ebc2b5225c62cf0b609c599d55fdc9d1f101af4c51de38a1dea1710d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1267aba26b012ba18bc6f2c57a046d5a3633f3886e6c934ee6620db096a9b164"
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
