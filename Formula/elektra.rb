class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://www.libelektra.org/home"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.11.tar.gz"
  sha256 "2c9c7ec189d5828a73f34d6a3d2706da009cb5ad6c877671047126caf618c87a"
  license "BSD-3-Clause"
  head "https://github.com/ElektraInitiative/libelektra.git", branch: "master"

  livecheck do
    url "https://www.libelektra.org/ftp/elektra/releases/"
    regex(/href=.*?elektra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "c5f7a09d64f19cd3474dae214fb24d33c7fd8935eb57c6eebcbfba9e06956825"
    sha256 arm64_big_sur:  "82e55cb29a2e11c555dc23e617581ab4cd2e1f699c9005e1c9614fc25281c505"
    sha256 monterey:       "4c979274ddcddc7375d23dd2bcd87472fc6b95ecf4acdd1cd995e119f5d7a657"
    sha256 big_sur:        "1b3480d48cd12985264bd1380aa78ecd5384f403a8288669156d3b170cf914ac"
    sha256 catalina:       "c44e21a140c93ec947b905ec626929c4811fa463499ebb217e22364d752a8df9"
    sha256 x86_64_linux:   "b74dccff8c603fcf6e55431b58995ba78e6b1f43a6d6336f127ab38534e685aa"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBINDINGS=cpp", "-DTOOLS=kdb;",
                            "-DPLUGINS=NODEP;-tracer", *std_cmake_args
      system "make", "install"
    end

    bash_completion.install "scripts/completion/kdb-bash-completion" => "kdb"
    fish_completion.install "scripts/completion/kdb.fish"
    zsh_completion.install "scripts/completion/kdb_zsh_completion" => "_kdb"
  end

  test do
    output = shell_output("#{bin}/kdb get system:/elektra/version/infos/licence")
    assert_match "BSD", output
    shell_output("#{bin}/kdb plugin-list").split.each do |plugin|
      system "#{bin}/kdb", "plugin-check", plugin
    end
  end
end
