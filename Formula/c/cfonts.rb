class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.1.4rust.tar.gz"
  sha256 "49228dc3dd4529bd86d537f46c8aa9a47043f060ec7d050e5cb739a030222407"
  license "GPL-3.0-or-later"
  head "https://github.com/dominikwilkowski/cfonts.git", branch: "released"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]?rust$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f167627afafb77e3b656e62d8bce4f0c173be483a249970118c3a3b719047ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a8f56071aee17b3bf2b44d8d1a493c8c4f67ef792671e89370343b42ff28341"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0acfc33654009c79fff58d85cc722eef0f3f734406ae0e56077e2f4eb4cd8962"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e7fb969e87889bb2c34ad4afffe4a08d420b32f7c3caf2309f080bd9bbfd1e4"
    sha256 cellar: :any_skip_relocation, ventura:        "11ba6209447f1eece3be7ca60015f103184bcf6e1d6f83c1770bf7a96e8d1ba5"
    sha256 cellar: :any_skip_relocation, monterey:       "70ec7fc2c6d6633f910d05267e5e1b6798f3b284385053592e8913ea96bbacaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4e0005d9f0182e746081771d318c19783337ad1b09ccd76b411df7de8e67c0b"
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
       ████████╗
       ╚══██╔══╝
          ██║  \s
          ██║  \s
          ██║  \s
          ╚═╝  \s
      \n
    EOS
    assert_match "\n\ntest\n\n\n", shell_output("#{bin}/cfonts test -f console")
  end
end
