class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "16",
      revision: "ae775781dbeb2763b4d81ad87cb2342a4fd79627"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f8c33e90d161462cde41b8478e3888b11edc0f66fb44020013e8e95e6626c36c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e6fc6d9a26ae8d6feffc6988320edf81863c016b2a79b5bc810535c29af1124"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80727bb03a4a3634186642354ddd57dfbce3fe89ddfafc72ea57bf77b6843cc6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621d8c8e74a4f6f79927103e66da64da81f6da507d9bb57f140777f6276f4af3"
    sha256 cellar: :any_skip_relocation, sonoma:         "87a69fc6726751688c0788ec03b247e30e2144f6587ca8c9ec59ba050d2ca3b4"
    sha256 cellar: :any_skip_relocation, ventura:        "20d4b6eb92b0164f67fb3ad9ff59480aedb7553faf21b0df1c1ce7f693454dd7"
    sha256 cellar: :any_skip_relocation, monterey:       "d808818b120b3ea8e1ef9eb3099cd1ae6ce1053878291f26b471bfc097c4c06a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d9fbeff5e48a98bcbab78a21fdcb350668e270f5d8a6bcddf5e29dd72f9fd616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3af0fc40824aa6b3cf776c443eee3e23cd9572bdec30ab06f468ffd058501801"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output(bin/"neatvi", ":q\n")
  end
end
