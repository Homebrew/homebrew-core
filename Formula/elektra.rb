class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://libelektra.org/"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.4.tar.gz"
  sha256 "e1f11f063ab262ce056238ca17aa60442a450a0bb6c5f57a9959df0365576bc6"
  license "BSD-3-Clause"
  head "https://github.com/ElektraInitiative/libelektra.git"

  livecheck do
    url "https://www.libelektra.org/ftp/elektra/releases/"
    regex(/href=.*?elektra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:  "1008c3fe882d99290df6946ec1d74e76068df35e64ed316a2ec761f35900815f"
    sha256 catalina: "e96e11f3508ac5ba9cc3bb4f4f5b251d9792f071fec62afb97d6d73f391a73f4"
    sha256 mojave:   "19336159915f7a97c7028c867f2515acd6e6e0e10061362089b22cded8f53f2a"
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
    output = shell_output("#{bin}/kdb get system:/elektra/version/infos/licence")
    assert_match "BSD", output
    shell_output("#{bin}/kdb plugin-list").split.each do |plugin|
      system "#{bin}/kdb", "plugin-check", plugin
    end
  end
end
