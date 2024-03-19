class Dialog < Formula
  desc "Display user-friendly message boxes from shell scripts"
  homepage "https://invisible-island.net/dialog/"
  url "https://invisible-mirror.net/archives/dialog/dialog-1.3-20240307.tgz"
  sha256 "339d311c6abb240213426b99ad63565cbcb3e8641ef1989c033e945b754d34ef"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://invisible-mirror.net/archives/dialog/"
    regex(/href=.*?dialog[._-]v?(\d+(?:\.\d+)+-\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "434cac7efd70206308f50103224720f55077f3e919debc3931688578ad4542d2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "051555b432122358fdd16e83770fdcda7bfd39b40b670ea013fc70ebb5e13516"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80a9f58e97db31e45134e8c5e14f792ae1e1547bd3a9569a7a7d16123e6b3732"
    sha256 cellar: :any_skip_relocation, sonoma:         "17a2372888ee3845cc799e55644848a3a8d913590349a3e0762b9f3dc393282c"
    sha256 cellar: :any_skip_relocation, ventura:        "4136e95d3cdc76671659157fc6dc22efd950cd788fefdfef385b10ee1eb424c7"
    sha256 cellar: :any_skip_relocation, monterey:       "df0d7092615ffccbc05bc34dee999e9944b116d50ef20a811834df5d12ff4092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bbea0219f71cb4010a3e9b71cf3c13a161e080074df077098f19502b967b4ad"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-ncurses"
    system "make", "install-full"
  end

  test do
    system "#{bin}/dialog", "--version"
  end
end
