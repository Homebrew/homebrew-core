class Atool < Formula
  desc "Archival front-end"
  homepage "https://savannah.nongnu.org/projects/atool/"
  url "https://savannah.nongnu.org/download/atool/atool-0.39.0.tar.gz"
  sha256 "aaf60095884abb872e25f8e919a8a63d0dabaeca46faeba87d12812d6efc703b"
  license "GPL-3.0"

  livecheck do
    url "https://download.savannah.gnu.org/releases/atool/"
    regex(/href=.*?atool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9772f860038b7901645159630516942318faf1c300f47ff7d393b018993c2927"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a498806923cebdf510cefbd1dc5e1dd8e88b8e50e317e3531dccb08d808d09f"
    sha256 cellar: :any_skip_relocation, monterey:       "ca6b1d8ed7a241588990b84006bd047b05734f9f70a50354d2ea129e0adfdaee"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9492434916b077c29cfadeb04d853748db63bd54e9f4869f4efb03bcc3f00de"
    sha256 cellar: :any_skip_relocation, catalina:       "78769c7244232e9ba4b403f0dae560e61bc69d08d76936e9797c3f9b18b778f3"
    sha256 cellar: :any_skip_relocation, mojave:         "afc78205d3558294d008a801f7b06e8fcc94509a34bb0832f914575c196d6f8d"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0f28ddbd664675c6b3fe440f6cfba6ac8cc6fc1f97141979bbce485080a759f4"
    sha256 cellar: :any_skip_relocation, sierra:         "656b59fcaa79956c81af4ce21afc06dbf9f6ffaecc0ff52b1a063da2c911fe89"
    sha256 cellar: :any_skip_relocation, el_capitan:     "dcfdcb720aa3704b9103aa01bb8efac42d24327bc8664baa420a9a69d75a98b6"
    sha256 cellar: :any_skip_relocation, yosemite:       "efdeeb165e146f4a76477417d2af9c60e2f776d06081bb579ff73ceb296a899d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9772f860038b7901645159630516942318faf1c300f47ff7d393b018993c2927"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "example.txt"
    touch "example2.txt"
    system bin/"apack", "test.tar.gz", "example.txt", "example2.txt"

    output = shell_output("#{bin}/als test.tar.gz")
    assert_match "example.txt", output
    assert_match "example2.txt", output
  end
end
