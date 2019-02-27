class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.8.26.tar.gz"
  sha256 "5806cd0b2b1075fe0d5a303649d0bd9365752053e86c684ab7c06e7f369155d3"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    sha256 "0e237b881bfd86eaeb4aff21cc7c077e2951ad7388e9b2ab1a078f39acd4abac" => :mojave
    sha256 "c6d60cf7da3fb2c3b9c92dc7a256ba531b134f05965d1fb7dca192f0233305cb" => :high_sierra
    sha256 "2f710c6230a61223bdf0060ebf7808725b5779a1aaedb23e3344c3d996587afd" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBINDINGS=cpp", "-DTOOLS=kdb;",
                            "-DPLUGINS=NODEP", *std_cmake_args
      system "make", "install"
    end

    bash_completion.install "scripts/kdb-bash-completion" => "kdb"
    fish_completion.install "scripts/kdb.fish"
    zsh_completion.install "scripts/kdb_zsh_completion" => "_kdb"
  end

  test do
    output = shell_output("#{bin}/kdb get system/elektra/version/infos/licence")
    assert_match "BSD", output
    Utils.popen_read("#{bin}/kdb", "list").split.each do |plugin|
      system "#{bin}/kdb", "check", plugin
    end
  end
end
