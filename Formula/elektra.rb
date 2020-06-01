class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.2.tar.gz"
  sha256 "6f2fcf8aaed8863e1cc323265ca2617751ca50dac974b43a0811bcfd4a511f2e"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    sha256 "a365f031dffd695ded3f1b1aa64320791caf134002f8d7ee89beea4469a5de00" => :catalina
    sha256 "c2964e938a38c91b3d0322af3eef8ffc397f92b9d2de5365133f50f8142ed532" => :mojave
    sha256 "6db5a9e59b9db54069636ed12fd73d405447703512717847e4839875c30fe586" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBINDINGS=cpp", "-DTOOLS=kdb;",
                            "-DPLUGINS=NODEP", *std_cmake_args
      system "make", "install"
    end

    # Avoid references to the Homebrew shims directory
    inreplace Dir[prefix/"share/elektra/test_data/gen/gen/highlevel/*.check.sh"],
              HOMEBREW_SHIMS_PATH/"mac/super/", ""

    bash_completion.install "scripts/completion/kdb-bash-completion" => "kdb"
    fish_completion.install "scripts/completion/kdb.fish"
    zsh_completion.install "scripts/completion/kdb_zsh_completion" => "_kdb"
  end

  test do
    output = shell_output("#{bin}/kdb get system/elektra/version/infos/licence")
    assert_match "BSD", output
    Utils.popen_read("#{bin}/kdb", "plugin-list").split.each do |plugin|
      system "#{bin}/kdb", "plugin-check", plugin
    end
  end
end
