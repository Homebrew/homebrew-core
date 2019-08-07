class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.0.tar.gz"
  sha256 "fcdbd1a148af91e2933d9a797def17d386a17006f629d5146020fe3b1b51ddd8"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    sha256 "37e844cb59c8fc378e232ac0a86d053a6a7a65b797672565907f86dfdde1647b" => :mojave
    sha256 "b8b31fdbd8f73df0671eed8bd348bef1eea631ce310f0c10037d61a40090ce2c" => :high_sierra
    sha256 "141d0e2788c329dd27801cf1245cabe3893d898139996c75997519338a42acb8" => :sierra
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
