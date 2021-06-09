class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.6.tar.gz"
  sha256 "c8e75f4d21bf3bd6b1028e776af9ff644a17a7dfbb1f2052f50392767deea197"
  license "BSD-3-Clause"
  head "https://github.com/ElektraInitiative/libelektra.git"

  livecheck do
    url "https://www.libelektra.org/ftp/elektra/releases/"
    regex(/href=.*?elektra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "3fab7c4f9a07da74617e98751b053c62d7d72a478c195b5c819d2d5c053c8310"
    sha256 big_sur:       "758cd60b10a8cbcb77bd27192b81847ac350ae2d73682f2dfa109c3f93b9205f"
    sha256 catalina:      "32521c4e03f40813c1a9f6410f002bbdad780cc28f8eff235fec0cec4f2558b0"
    sha256 mojave:        "3096290a9e2d9e86044cbec05c6c4b65576b0f8c6e7253b0cae1d9a3c1b60125"
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
