class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.8.26.tar.gz"
  sha256 "5806cd0b2b1075fe0d5a303649d0bd9365752053e86c684ab7c06e7f369155d3"
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
