class Polypolish < Formula
  desc "Short-read polishing tool for long-read assemblies"
  homepage "https://github.com/rrwick/Polypolish"
  url "https://github.com/rrwick/Polypolish/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "7a9b803aac87a7963c08c162c502f90f9cf93b1f58d1502047eefc43aca65bde"
  license "GPL-3.0-or-later"
  head "https://github.com/rrwick/Polypolish.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "573d4d8f109f484e2b03832122174f6c3cb16bdfe357f617306233f4613da268"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27e21ac9ec859c4d3a4cac3894979bbf348f2749212961dfbda022b23a93fb41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75763e9f7d2d958960e52b71f14abce7cfacb5613c939ea85b0dfbc3e08f6117"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "66487941bbfaf2f02730c793390833f31c2e077388ff58c111924171a4268161"
    sha256 cellar: :any_skip_relocation, sonoma:        "4212609959e8a9f235f9f47f89c7b482676f51d194b3fd65204bb281f7ac5a8a"
    sha256 cellar: :any_skip_relocation, ventura:       "f7920a878f69050433f0e45de27d916dba31117ceed34751b650ba1c35a5f7ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dde17d5e05b5b7b1418a8840d1cbd60d83636946571e7dcd27c0a79f94fa32bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49147fa1a9be87eb69b0ad655335450c7cb1ae203d0b81f6bda1daa913511471"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    output = shell_output("#{bin}/polypolish polish test.fasta")
    assert_match "polypolish", output
  end
end
