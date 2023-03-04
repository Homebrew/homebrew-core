class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://www.libelektra.org/home"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.9.12.tar.gz"
  sha256 "38238ba4a5318f999dc3045da06467abf529344dc46ad3fdf42bdca0155e149c"
  license "BSD-3-Clause"
  head "https://github.com/ElektraInitiative/libelektra.git", branch: "master"

  livecheck do
    url "https://www.libelektra.org/ftp/elektra/releases/"
    regex(/href=.*?elektra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "1801e7a382c54e7255aba5895a5bf466da858b0da1415fc27be880ab6fcd819b"
    sha256 arm64_big_sur:  "6de9a7fb96a958a072c91a89003bfe6f31e2465b376a956d7fc9daa9ac6bc1b4"
    sha256 monterey:       "453a2a841b239dff25047f8ed33d1fb6b4610fd66598c1fe6500470775406477"
    sha256 big_sur:        "547232183208cf27a2f5dd419e8cdbeac1215929be2f47d66d8812a405c259ed"
    sha256 catalina:       "26aaa5a13477ce3fd62453b41bf9d9fb68e46a9eea81bdbbb51e43fa05f919ba"
    sha256 x86_64_linux:   "8e3312252acc9caf4a405b33bf8a779308a673da49b4dd23846bba849b283d2e"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    args = %w[
      -DBINDINGS=cpp
      -DTOOLS=kdb
      -DPLUGINS=NODEP;-tracer
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
