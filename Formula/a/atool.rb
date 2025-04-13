class Atool < Formula
  desc "Archival front-end"
  homepage "https://savannah.nongnu.org/projects/atool/"
  url "https://savannah.nongnu.org/download/atool/atool-0.39.0.tar.gz"
  sha256 "aaf60095884abb872e25f8e919a8a63d0dabaeca46faeba87d12812d6efc703b"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/atool/"
    regex(/href=.*?atool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c90268b9621aa25c6cae07db4313c857cc3e4a6ece918a9d55753e1b8055fef1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c90268b9621aa25c6cae07db4313c857cc3e4a6ece918a9d55753e1b8055fef1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c90268b9621aa25c6cae07db4313c857cc3e4a6ece918a9d55753e1b8055fef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "32ab886a03969d9890dc6867a45164535fd1f9e66956d8d29b8bff7c70b8ddc2"
    sha256 cellar: :any_skip_relocation, ventura:       "32ab886a03969d9890dc6867a45164535fd1f9e66956d8d29b8bff7c70b8ddc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6b9b7f3b9432817b9a5bfdc5b5875ca2cda6c417811628086a06d1b11ae7e92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c90268b9621aa25c6cae07db4313c857cc3e4a6ece918a9d55753e1b8055fef1"
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
