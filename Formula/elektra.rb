class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.9.tar.gz"
  sha256 "834da360170daa632bbb46dd2e819271327dce1c51be1d7bb2ec22311ded54cb"
  license "BSD-3-Clause"
  head "https://github.com/ElektraInitiative/libelektra.git", branch: "master"

  livecheck do
    url "https://www.libelektra.org/ftp/elektra/releases/"
    regex(/href=.*?elektra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "911dedf18b89fcc63cebaa401aabc8089c2e8d4f1a615ca1461f02e8e3e27868"
    sha256 arm64_big_sur:  "0d372628746983f988cf4faf5c40f7e569abcfedd74ff9f9c3d99d212049472c"
    sha256 monterey:       "674db8f4f9e12edc936c96398fa6f6c246b7d64d63d600ae242bb5eac8d0eb52"
    sha256 big_sur:        "cfbb207afae121255568a4eceb82169c8e0c9d18cea4e503bc0f9c551108b06a"
    sha256 catalina:       "e2107bc4de9b958667893f10e9b38091447a2496d60b7434b4ee508cff76e5ae"
    sha256 x86_64_linux:   "719f982dd600aaab97c9c8a75475c995511be91bd243ac13576920bdf7f4413a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBINDINGS=cpp", "-DTOOLS=kdb;",
                            "-DPLUGINS=NODEP", *std_cmake_args
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
