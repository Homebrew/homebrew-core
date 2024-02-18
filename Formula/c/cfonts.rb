class Cfonts < Formula
  desc "Sexy ANSI fonts for the console"
  homepage "https://github.com/dominikwilkowski/cfonts"
  url "https://github.com/dominikwilkowski/cfonts/archive/refs/tags/v1.1.3rust.tar.gz"
  sha256 "e5b2be2d1ce4f4e5b345d755425bc9841a9c1e35c4025ec83dab4f6c38291d87"
  license "GPL-3.0-or-later"
  head "https://github.com/dominikwilkowski/cfonts.git", branch: "released"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)[._-]?rust$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7681a6a0d6edccf2c76341fb23ca236e6a8bfb367b547020efc19bb017775bff"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7564bc938f4c813c9acf69b0b72a23ef286dcf16b54d8fc9cf2b87971c52eee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ecc9ce799ddaa0dcbfd77e04721d12641ac6a5ed0273ceaeb993a92d9ff6e68"
    sha256 cellar: :any_skip_relocation, sonoma:         "a2e107e298e535183cbc93da3a7f322b21ff2382b94dd6fb3b1aa7ea43263061"
    sha256 cellar: :any_skip_relocation, ventura:        "f6aa57f965ba72b449b015944825d9a621f4b2b2673192c222eb57dde6f57aa6"
    sha256 cellar: :any_skip_relocation, monterey:       "4a41864e09573a908b9d683c73ed60389576de0a20f1ae8b7b2e3afeebf03f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "068755e2bb56a662272a4469e26551a8ae65db3f9913bd1c347d0fd6e7677e92"
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
