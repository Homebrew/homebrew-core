class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://www.libelektra.org/home"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.14.tar.gz"
  sha256 "e4632bb6baa78f6a68c312469e41fd1ef07406571749e32f2645b1858d01a58d"
  license "BSD-3-Clause"
  head "https://github.com/ElektraInitiative/libelektra.git", branch: "master"

  livecheck do
    url "https://www.libelektra.org/ftp/elektra/releases/"
    regex(/href=.*?elektra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "dd22fa227ae0db754942b45f3e3dddb6b8e49473cc5350e3ae0b55a10a9f00e0"
    sha256 arm64_monterey: "eb73b3b005a9957062026fc7a02bc63da38cf772a9867c60315b26d877271676"
    sha256 arm64_big_sur:  "9394dee0d085cc16f57d2ee2582a1492bf2e97c5a72407025aaa991d6b807ac8"
    sha256 ventura:        "7964baa448d4f2633c75ed74bebe5b5a4c716ef53988b1a13c43504272470565"
    sha256 monterey:       "7ef68f560a600516a7d75435869f6feddf827bf8e78e481175bc33ebcebef062"
    sha256 big_sur:        "108e886c6f9fcf8c2f632075de344e15fca292ceb7d3147732bce82392b157c2"
    sha256 x86_64_linux:   "2db60062daba452efe680b06b99ae8e453f7e938c2e04655d814bcaed94a259b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBINDINGS=cpp", "-DTOOLS=kdb;",
                            "-DPLUGINS=NODEP;-tracer", *std_cmake_args
      system "make", "install"
    end

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
