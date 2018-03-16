class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.8.22.tar.gz"
  sha256 "962598315619d5dff3a575d742720f076dc4ba3702bd01609bfb7a6ddb5d759f"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    sha256 "a285397a8ef165eb825773c6ad452ed9fd97283b93eb6f0a86de2a222624cbe4" => :high_sierra
    sha256 "cac9779dcc8c1cc998b30274fc3ab137d94644ba25b1fb5a8dca6c922b2679cd" => :sierra
    sha256 "b393066a4c05790003e095101ac08e3b5b650788dd45f5d3d7530781e731ef45" => :el_capitan
  end

  option "with-qt", "Build GUI frontend"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "qt" => :optional
  depends_on "discount" if build.with? "qt"

  def install
    tools = "kdb;"
    tools << "qt-gui;" if build.with? "qt"

    mkdir "build" do
      system "cmake", "..", "-DBINDINGS=cpp", "-DTOOLS=#{tools}",
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
