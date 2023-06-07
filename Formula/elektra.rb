class Elektra < Formula
  desc "Framework to access config settings in a global key database"
  homepage "https://www.libelektra.org/home"
  url "https://www.libelektra.org/ftp/elektra/releases/elektra-0.10.0.tar.gz"
  sha256 "cb56e40b37c42e1e235cf9e76c9250024f912cbb61cca1a2888f9305f5228dcd"
  license "BSD-3-Clause"
  head "https://github.com/ElektraInitiative/libelektra.git", branch: "master"

  livecheck do
    url "https://www.libelektra.org/ftp/elektra/releases/"
    regex(/href=.*?elektra[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1c7f7a338c04ae3cd098f34da692b29fb6c140a7649f6e5085d2c7422d81f05f"
    sha256 arm64_monterey: "1e00a8c15469ddb41ed19199d70f45bf5f9860462624d85d995201955f7d40f6"
    sha256 arm64_big_sur:  "61dcdf0bde9f91b645ee62fb249773bf4b5329f2cc73a560a61b1faf05a6db74"
    sha256 ventura:        "08c98ad46aa2c3bca188e2a0ce868143b6268e14f51f4b6745647dd72fd812c6"
    sha256 monterey:       "d1839fcfc1adc74a6c34c38a1e4a3fae8863b95709ccaf870f738b9e15f79504"
    sha256 big_sur:        "cdc726ab4def7a1ad1b94d73d79ec20f5c7288e9519bd8511bfb39776354f668"
    sha256 x86_64_linux:   "e9684e27e8002cb22554442f47fba4dcf00cb0bd0d1483d746c9946647235072"
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
