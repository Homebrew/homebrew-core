class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://davidesantangelo.github.io/krep/"
  url "https://github.com/davidesantangelo/krep/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "a1aad2904df970ce557603f19b4d619be6ef464dd4a9c685d361450c50a9cfd4"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "344fd0cc3c14c4e8e757bc4c7b83cb5d2c568935f021faee0c2762b794829652"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "735169c73ed3610ec8dc079216086ff06464fba9db32bc3b6899e1e59992e6f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "16b777782f2aa49e6eb4866c2cab287d8f801893f4bfdcc2c75092d676733cd5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c327701bf9824a272194d492d705f46d528b3ea0608cf8c8a612c1b89ed830b"
    sha256 cellar: :any_skip_relocation, ventura:       "60361e418894afcba4e48e9ddcc17104c830f9470ad21743932985311e754251"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8061ccae7328e5d40f4842c3fdc66503880dd2cfdf840b5d57c436fdc002e919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ee3401fc0295b747eb1af5d787538af453240f369c89544f3628fbdd01e05f8"
  end

  def install
    # Fix to correct version
    odie "Remove version patch for v0.2.1" if version >= "0.2.2"
    inreplace "krep.c", "VERSION \"0.2.2\"", "VERSION \"#{version}\""

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}")
    assert_match "Found 1 matches", output

    assert_match "krep v#{version}", shell_output("#{bin}/krep -v")
  end
end
