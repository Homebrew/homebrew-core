class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "13",
      revision: "3e2c35c93f7c86a12e4512c2c892440450a62bbf"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae80268eed104e0e719d2fede43ea6ec0aa9ccc4d55edd53e7e495fd1d4757a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a2402ccf94c2df84d5eb259931866428b1e9c547737d5c12643ac29c90f3950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7622eefe56b12b4bb4fd22b8bcf2e7b021a8caa19e0a952664a2779002c20789"
    sha256 cellar: :any_skip_relocation, sonoma:         "f92fdc755e3a7c8e10bfe5731aabe603fab86b42537a99ffef38448cd6783790"
    sha256 cellar: :any_skip_relocation, ventura:        "d90a09b9866ffe89fb6a777e41eb0fc7bb8164cd4c7b2e4bc78a8ab1f6b54186"
    sha256 cellar: :any_skip_relocation, monterey:       "3703da96ad624e6d60d2c66123065b263311a17e86cae43381b352e00206346b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17377d1eb88a423700efe751e2a6c068929248aed6726b716cc8002e3e89fa61"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end
