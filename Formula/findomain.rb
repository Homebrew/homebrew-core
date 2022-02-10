class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/6.1.0.tar.gz"
  sha256 "5499bf1b07be83bb2d08be43bdeace77b19a461e81fb773e2ec89f5b01b52e85"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fc3b22319bdb9539e5117ec8f0ecc8d553acdc76ea5110d914ff2aa5ace29ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "039a08eb55859fc31e3130b58d92afc24417b980cfd362830d7dcd0b6ed48957"
    sha256 cellar: :any_skip_relocation, monterey:       "3763c6a250393ffbd95f03a4121b6f6ac4617c84eba6d216b3eb5aa169b740cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "af84662a2c9f69f3d9eda79644fb47c3c298d6e6638382512fd08da8b9e6329a"
    sha256 cellar: :any_skip_relocation, catalina:       "0695e751da3c3795eef4a020d7259b048b5c592ac9318d68e09c586015c56a99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f263e31385d65066cc0368cf82d7fdf9558faeaa7c734181adf56f1e5451e69b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
