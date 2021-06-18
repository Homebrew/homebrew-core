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
    sha256 arm64_big_sur: "b246eb7351b10188c76762094e9e6bd08a8a6119cb8589fd244b304c54355608"
    sha256 big_sur:       "4bcef10484817f1cad4335703c2714f6e5dac109766bb7f403fc3ed16103b5f9"
    sha256 catalina:      "be7504905eaae104e3f59fc90adad96c2ea845d8f4f95ca0fbb261760afe45f1"
    sha256 mojave:        "18dc59bc3c7dbbea60eae22d88f89157413c35fe285ea46fe0cbd884e5d3535d"
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
