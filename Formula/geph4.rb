class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.2.3.tar.gz"
  sha256 "1d6578a21df81bf4f7b061db5a76be41f1597ebc977974c24f9db59441f0cf46"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6653002d99929f1342e45b655fd05f3d81b3338f162281dafd9df31179b363a5"
    sha256 cellar: :any_skip_relocation, big_sur:       "373c9ad783bc6a720b05ad3d583c02d019f0d5f23208829b566d270eb8d815f4"
    sha256 cellar: :any_skip_relocation, catalina:      "97408e07ab070916257a9e75e0c5e30cb31681f2ee10a51fd2d7eaf8613eb904"
    sha256 cellar: :any_skip_relocation, mojave:        "de0631676a901b1d172b78f3f1e5a78b42df8e030fae980185614bbdc752593f"
  end

  depends_on "rust" => :build

  def install
    File.delete("Cross.toml")
    remove_dir(".cargo")
    Dir.chdir "geph4-client"
    system "cargo", "install", "--bin", "geph4-client", *std_cargo_args
  end

  test do
    assert_equal "{\"error\":\"wrong password\"}",
     shell_output("#{bin}/geph4-client sync --username 'test' --password 'test' --credential-cache ~/test.db")
       .lines.last.strip
  end
end
