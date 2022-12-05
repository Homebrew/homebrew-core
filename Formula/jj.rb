class Jj < Formula
  desc "Git-compatible distributed version control system"
  homepage "https://github.com/martinvonz/jj"
  url "https://github.com/martinvonz/jj/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "327b314895c5a745c764bfc65c4529526d632f9c705223aadb9a1a9df46d1aba"
  license "Apache-2.0"
  head "https://github.com/martinvonz/jj.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "dbc2425af53f76825a156ea37eb1dc07b91f6b3c7b42a387c68cebc3a1abf3ce"
    sha256 cellar: :any,                 arm64_monterey: "3f2be89fa77a5e3b95d111728f7ecf0e112d1c42a757e11ab2dfec3f67c9240d"
    sha256 cellar: :any,                 arm64_big_sur:  "e84e321994ba5567a14bf20e0faafcffbf47a9c11ee80f84734915561944b414"
    sha256 cellar: :any,                 ventura:        "ace5f912e2bef127bdd8a12c47342298ee28aa2d3ec5a1cc724cfd46e4b2c0f5"
    sha256 cellar: :any,                 monterey:       "19afd506a426d68190ccd3ced98804fbafcbbec02c293688717c32b5fdeceb77"
    sha256 cellar: :any,                 big_sur:        "77d471140cacda3819826b17dec0a451c5328141b04f324cfba458b2f1067ccc"
    sha256 cellar: :any,                 catalina:       "588a26d6a31f505f7e413924b34cfebcd679b4f3b44856b70046e36e3aaaf5db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "319452669e2ff05871e795c624f641a7bd31ff16123ac1abde6af43affc77d55"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", "--no-default-features", "--bin", "jj", *std_cargo_args
  end

  test do
    system bin/"jj", "init", "--git"
    assert_predicate testpath/".jj", :exist?
  end
end
