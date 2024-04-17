class Datamash < Formula
  desc "Tool to perform numerical, textual & statistical operations"
  homepage "https://www.gnu.org/software/datamash"
  url "https://ftp.gnu.org/gnu/datamash/datamash-1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/datamash/datamash-1.8.tar.gz"
  sha256 "7ad97e8c7ef616dd03aa5bd67ae24c488272db3e7d1f5774161c18b75f29f6fd"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "521ebd6e3d990405d32e4bdd6ea07c257358f7f780889060df38d18acabe9bc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89b84e0e7e30808894613161483b8bb6005561d652522cdc399f1e6d1d00e34a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16e17344961038b0a719392d53f7968053df3680674554c862b0b4f36f4f86c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd5fd4c830c5ec57572d40a6221088ce3915ec53d273325fa44443c84d21d051"
    sha256 cellar: :any_skip_relocation, ventura:        "fc4d5134556554c64c14314007087e52810d1ec1c9b1761536da9115333e170a"
    sha256 cellar: :any_skip_relocation, monterey:       "efb5a8e92a90b49d4784875aff3d2bbeaddf708633a1f7533730979d81354bf8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bf80adfcba648b010674056c1abd3cca17a71bd717f81aed0c0d15fbf11abea"
    sha256 cellar: :any_skip_relocation, catalina:       "ffadf24c7def1e77a197952a3e31edbfbb4fc246d373b78c3c0671839d86b422"
    sha256                               x86_64_linux:   "d6937a2c3ab4e5d40b9994e93c8449d2b7231d58b4a7bce60a4866acf946a212"
  end

  head do
    url "https://git.savannah.gnu.org/git/datamash.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    assert_equal "55", pipe_output("#{bin}/datamash sum 1", shell_output("seq 10")).chomp
  end
end
