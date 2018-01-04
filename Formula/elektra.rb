class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.8.21.tar.gz"
  sha256 "51892570f18d1667d0da4d0908a091e41b41c20db9835765677109a3d150cd26"
  head "https://github.com/ElektraInitiative/libelektra.git"

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
