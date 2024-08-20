class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/lsd-rs/lsd"
  url "https://github.com/lsd-rs/lsd/archive/refs/tags/v1.1.4.tar.gz"
  sha256 "f511a70b7452a610011849aa6f22c6362384be36d83ce8df6a0471f718c5dc18"
  license "Apache-2.0"
  head "https://github.com/lsd-rs/lsd.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33bac5a7281307575a2980441b001c256a2abf5b6a5581ba03292b1fb449b7a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e5512f1a3a37ac5456dcf29c355952b075a93e1c09076a8dea2bcc4fce172d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84c346c2d1024fc4392356f2f1110fc81eabc21bb8d652e0155ef5c7a097faed"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ea048ecedc15e1dc3325a015100be118b44b5338db3ce13caecfd422bcf39e1"
    sha256 cellar: :any_skip_relocation, ventura:        "6770cd1b7aaba11a761c1c0810183734fbdcd63fe7ab4f30f54ee6b596c3053b"
    sha256 cellar: :any_skip_relocation, monterey:       "2bdbcf34d772c257d455bb6d7a37f16e880be81c2faf4501c4d951b078df107d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f4dedfc68c712e2ef1cf084b2f3d59e37424b56f587e19c58c618dbd3af929b"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args
    bash_completion.install "lsd.bash"
    fish_completion.install "lsd.fish"
    zsh_completion.install "_lsd"

    system "pandoc", "doc/lsd.md", "--standalone", "--to=man", "-o", "doc/lsd.1"
    man1.install "doc/lsd.1"
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
