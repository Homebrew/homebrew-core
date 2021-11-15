class Neatvi < Formula
  desc "Clone of ex/vi for editing bidirectional utf-8 text"
  homepage "https://repo.or.cz/neatvi.git"
  url "https://repo.or.cz/neatvi.git",
      tag:      "09",
      revision: "a3b79df332e3c5804ae57c0348549ff35a69f262"
  license "ISC"
  head "https://repo.or.cz/neatvi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "860f291c9c0b866ccf6e79fea4fae328122e69bc54b50823e68cebd69ef5b791"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54c65ed58e6d27871850aa722ee40fe2d72af036bb255a41ba9d0299c8b84479"
    sha256 cellar: :any_skip_relocation, monterey:       "574e00e2508ea4762fbfce35f3690b86533e1128fb299eb3e2f7731f9791218e"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc951c1348db9da286bf7cd1652f2aabe3b98757a834145c61fcf4de30a28b2c"
    sha256 cellar: :any_skip_relocation, catalina:       "dbfe05d495b19a8ea91806f6894c43502464d422cd4acc178da2e0aa7a824d3e"
    sha256 cellar: :any_skip_relocation, mojave:         "9e52be034eb7fdc6f6be1ac2bc307791aae1cdb83220783a511e7e3fb0ad6915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ae4df608e893ab8f0f0cb74df40081685d51a0c238b7a90f2b50e9afc6911f1"
  end

  def install
    system "make"
    bin.install "vi" => "neatvi"
  end

  test do
    pipe_output("#{bin}/neatvi", ":q\n")
  end
end
