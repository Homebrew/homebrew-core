class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.8.25.tar.gz"
  sha256 "37829256e102e967fe3d58613a036d9fb9b8f9658e20c23fa787eac0bfbb8a79"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    sha256 "12873d0d52af242cc27c7a97d11c0c67436f22aae1d30fb1ca8a7555bbde9f7c" => :mojave
    sha256 "f547a7e7adb757772d85a1fdc7de5854191605e2d116c87948da982fb4e35194" => :high_sierra
    sha256 "651713da404920c213be01e9495b7696e4183dfdc8cf5324d2152746d9b37013" => :sierra
    sha256 "f4646cbfc24e57040d68e1de12d92bad49c91886fb3a4318a43f7f3d47ba460b" => :el_capitan
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
