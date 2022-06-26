class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.25.2.tar.gz"
  sha256 "e078a4776b1082230ea0b8146613679c23d3b0d322706c987261df987a04bfc5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6d54394cacd4fac5f2aceb85a80f287b74f4534ff971b77de2021be54954e45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62838814ac245e65dce8998e5b009d9ee99849897c81af44199bd9a3c44db20d"
    sha256 cellar: :any_skip_relocation, monterey:       "d91055137b8898b9f133108ad6e07a643c5a4453140e8857c5ea45a1973ea639"
    sha256 cellar: :any_skip_relocation, big_sur:        "f52d497a23d97561087e1762a8a0ec878549fdec336ba3625c1089e581d27f0c"
    sha256 cellar: :any_skip_relocation, catalina:       "eeda6283cc709b2c85b7f6bdd62e7115edc2c3db730d96a6d277cf1abc9ed75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7a176037043824d9aa1cda3ca9d06527db5a2b3ed1c7f481e0857980ae21dbe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch testpath/"test.toml"
    assert_match "no [[gateway]] configured", shell_output("#{bin}/matterbridge -conf test.toml 2>&1", 1)
  end
end
