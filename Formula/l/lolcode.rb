class Lolcode < Formula
  desc "Esoteric programming language"
  homepage "http://www.lolcode.org/"
  # NOTE: 0.10.* releases are stable, 0.11.* is dev. We moved over to
  # 0.11.x accidentally, should move back to stable when possible.
  url "https://github.com/justinmeza/lci/archive/refs/tags/v1.3.tar.gz"
  sha256 "56a77f8a19e6284868e609dad0e4f1d7c9fe59a61398e338726b58016c1eecef"
  license "GPL-3.0-or-later"
  head "https://github.com/justinmeza/lci.git", branch: "future"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a103e4121ee76d588ecb6a4a7c157c316e6f2068a91d2a43a7ef44fe56c90e1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e012c9667cdf06c3dcec8959484ef8360dae7eff0a990956afc3e1355ba40154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fcbe3313bf9f5484ded64c50fa0036f11b83e12467a96c40636ef33aeac5d24"
    sha256 cellar: :any_skip_relocation, sonoma:        "572f3bbd7b11caafc7634441abe9951fdf0a74a399cf8cf30f750c4b120c92e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b11c7827b71720dc4095a5cf8246a57dcd94aafd1c9010ac05f71dca6a8c063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa3c6be395ffbf5dab1a5f65be4334889511c5ef765d5f06b0fad50000327725"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "readline"
  end

  conflicts_with "lci", because: "both install `lci` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"

    # Don't use `make install` for this one file
    bin.install "build/lci"
  end

  test do
    path = testpath/"test.lol"
    path.write <<~EOS
      HAI 1.2
      CAN HAS STDIO?
      VISIBLE "HAI WORLD"
      KTHXBYE
    EOS
    assert_equal "HAI WORLD\n", shell_output("#{bin}/lci #{path}")
  end
end
