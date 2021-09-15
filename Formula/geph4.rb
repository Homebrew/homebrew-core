class Geph4 < Formula
  desc "Modular Internet censorship circumvention system to deal with national filtering"
  homepage "https://geph.io/"
  url "https://github.com/geph-official/geph4/archive/v4.4.16.tar.gz"
  sha256 "e16a98ed8332ea8edbad7eba7b12b663907cba0b10f525ebf6541212067ee097"
  license "GPL-3.0-only"
  head "https://github.com/geph-official/geph4.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ceddff5fc9413f7659f8fb406af218fa1b57ed852cacfc85ec8ce17094dcdf6"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb276572d542af61eecf5a036f64b8597e6e5707cfd921ce5f80864ee117231e"
    sha256 cellar: :any_skip_relocation, catalina:      "41d3666c86611b75673bb365680b12d6904ee4fb9841fd7997d3561cbca8ecf6"
    sha256 cellar: :any_skip_relocation, mojave:        "37d20c36bfaa62c95a961d44b3f10e07a2e519dc5ff532530ac9d7e924522028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b87145786996b97c4eaa4fc79dfe5e9c84ac6d9e2e8fbb789b10e1acf224e13e"
  end

  depends_on "rust" => :build

  def install
    (buildpath/".cargo").rmtree
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_equal "{\"error\":\"wrong password\"}",
     shell_output("#{bin}/geph4-client sync --username 'test' --password 'test' --credential-cache ~/test.db")
       .lines.last.strip
  end
end
