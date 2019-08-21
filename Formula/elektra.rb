class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.0.tar.gz"
  sha256 "fcdbd1a148af91e2933d9a797def17d386a17006f629d5146020fe3b1b51ddd8"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    sha256 "6cd6b9560e5e51985af452fb2869dd03b4079b25b60b77dbe48a302b521cdbe2" => :mojave
    sha256 "3feaa48d0d4c1d0ba1ceb5e98ddda094f4cf3f64ffbb3c4d6809e827a6de1e84" => :high_sierra
    sha256 "963f9f7d9bea4fc866cc08cbae06e6fe473075f5afe2a2167aa9fbfbfde83d7e" => :sierra
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
