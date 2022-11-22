class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.1.0rust.tar.gz"
  sha256 "45c40dfc867234efc5c5a2df687ccfc40a6702fa5a82f2380b555f9e755508e6"
  license "GPL-3.0-or-later"
  head "https://github.com/dominikwilkowski/cfonts.git", branch: "released"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]?rust$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4839395e2a2c1226a2dd23aa731d27afe8a4f50b43eaa0502833201daf52e275"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b79e5bf0c884b7a2ab43f4bbb86066fa10c553ffd5ebc32a5d42e22c3e9f941f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bb55c4b03515bcfc6a39bbf17c7a1649c2cdea22dcfcb24b1e8feac86dfb039"
    sha256 cellar: :any_skip_relocation, ventura:        "e309ffeaee7abe5c6e3f23baf186ca4ac7bf7ec3f5de422294c71a1f99819775"
    sha256 cellar: :any_skip_relocation, monterey:       "91d7aac3437586c842097e89775d4870b607a0ef14fbe41f1bf8e96c19ee892f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e157f8fb65db360715a9383474866da5085caee1c66c4f0493df7095f83d54f7"
    sha256 cellar: :any_skip_relocation, catalina:       "3618ee4e3aabd9643541d8b02e981774c3fa57759a0d0ec380dc90ce00483d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e19d9ccc36cf13c9252f14865a0ce025e3358f04144742800cbd3a145dd9ccc6"
  end

  depends_on "rust" => :build

  def install
    chdir "rust" do
      system "make"
      system "cargo", "install", *std_cargo_args
      bin.install "target/release/cfonts"
    end
  end

  test do
    system bin/"cfonts", "--version"
    assert_match <<~EOS, shell_output("#{bin}/cfonts t")
      \n
      \ ████████╗
      \ ╚══██╔══╝
      \    ██║  \s
      \    ██║  \s
      \    ██║  \s
      \    ╚═╝  \s
      \n
    EOS
    assert_match "\n\ntest\n\n\n", shell_output("#{bin}/cfonts test -f console")
  end
end
