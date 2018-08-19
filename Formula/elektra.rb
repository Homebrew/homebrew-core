class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.8.24.tar.gz"
  sha256 "454763dd00e95e774a907b26eb59b139cfc59e733692b3cfe37735486d6c4d1d"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    sha256 "a8c5ce2977f85bf0451d6f95c6bc04b2f6431491681664424783b9a20964217b" => :high_sierra
    sha256 "c16c814f081317dc3dbd3593d062734784f2ee6733d695ea63c4900390f9e6bf" => :sierra
    sha256 "285a50672d49a6273f89fd81083e7e1f1c502dc52615a8f31b905ffef2e52482" => :el_capitan
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
