class Awk < Formula
  desc "Text processing scripting language"
  homepage "https://www.cs.princeton.edu/~bwk/btl.mirror/"
  url "https://github.com/onetrueawk/awk/archive/refs/tags/20250116.tar.gz"
  sha256 "e031b1e1d2b230f276f975bffb923f0ea15f798c839d15a3f26a1a39448e32d7"
  license "SMLNJ"
  head "https://github.com/onetrueawk/awk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9240fc9e7ecebf530d86c2c3de58cb313f2f43c02b767f92aad88f18b58645f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5856a1cbeffd667a6c5b806882dd171e1e07e4fc360c517879670d473e2c53d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "120228d2017aa47ba4b3bfc5f19a036c9faae95df04d0868c2b2deb114b8a914"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e7d70c9939caca5633d63b76cf7335e09acc043ead6161030d6509f17627c52"
    sha256 cellar: :any_skip_relocation, sonoma:        "8968128a1d73c936afcf91001b14acff3b61434c29da46dcc6633a0db110bafe"
    sha256 cellar: :any_skip_relocation, ventura:       "bcd5849c88f363e61d7b5a64ad66523b179bb0640c6ccb2d20bc73a5f16ff97e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eea9d168fda5dd37f829e640f2cede4388e4def78df435d7a80d9970791a2f88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58c95f701bae773a84aac466636229ae363c15b1943ae627d2065bcb16c2bc78"
  end

  uses_from_macos "bison" => :build

  on_linux do
    conflicts_with "gawk", because: "both install an `awk` executable"
  end

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "a.out" => "awk"
    man1.install "awk.1"
  end

  test do
    assert_match "test", pipe_output("#{bin}/awk '{print $1}'", "test", 0)
  end
end
