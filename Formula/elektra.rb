class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.2.tar.gz"
  sha256 "6f2fcf8aaed8863e1cc323265ca2617751ca50dac974b43a0811bcfd4a511f2e"
  license "BSD-3-Clause"
  head "https://github.com/ElektraInitiative/libelektra.git"

  bottle do
    sha256 "e621021dfaf81727f50302993a94b0f06eaccfc0c4d57c6879bbb0d3d5a42368" => :catalina
    sha256 "761e2bc6bbda33e08a6aebe9ea36d490d05b6bf0ec6e4d1bf3d9dc92ceb72ac0" => :mojave
    sha256 "f53a1b4ba82ab8165ec9b265e2fe71b1cbd97b47d9ce5e2607e7fe35a3814b0e" => :high_sierra
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
    shell_output("#{bin}/kdb plugin-list").split.each do |plugin|
      system "#{bin}/kdb", "plugin-check", plugin
    end
  end
end
