class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.7.tar.gz"
  sha256 "12b7b046004db29317b7b937dc794abf719c400ba3115af8d41849127b562681"
  license "BSD-3-Clause"
  head "https://github.com/ElektraInitiative/libelektra.git"

  livecheck do
    url "https://www.libelektra.org/ftp/elektra/releases/"
    regex(/href=.*?elektra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "5ed421b12c2ead45ba45c7807cd0916ef87f0eda49eab27693bb1077c1cb9fb5"
    sha256 big_sur:       "fbaacf726a77ec94ebf835aa77bc3db5c6fd7bec4f0895a58a70be8718c7ee9e"
    sha256 catalina:      "c3ec4af92a0e63e565ca517535c3b3306806bddf1b88878cbf731831ad61b6d0"
    sha256 mojave:        "e293f9a80501d0435021aa7acbfd6117afcc7928f8fe492bf48e1261064889b0"
    sha256 x86_64_linux:  "801cebd1353b5a54bf5712ca59f03ea0a8f0110e3e3aeed0dc2c678a5440224f"
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
