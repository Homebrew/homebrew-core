class Dylibbundler < Formula
  desc "Utility to bundle libraries into executables for macOS"
  homepage "https://github.com/auriamg/macdylibbundler"
  url "https://github.com/auriamg/macdylibbundler/archive/refs/tags/1.0.5.tar.gz"
  sha256 "13384ebe7ca841ec392ac49dc5e50b1470190466623fa0e5cd30f1c634858530"
  license "MIT"
  head "https://github.com/auriamg/macdylibbundler.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "00c51e669f0098b7a2a6271542b9b6be6909cb3634e2b458dfbc708357d6f9c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "26795436a10e6ed4ff9114682bf35cde4ce4dc3c69f93d8b6d41b34010f60d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f06d382fc981ab6ed57d9fd0257cb18481cb524128d88d3bd864c0720e435c91"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8749638bc5670b6a9c6f6fba7f609b2d72352639cf14cf10b9bc59c3f9ca3972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daba4f32451618f8bde33249c02d2e07a2a33080d4ce4e3f6b1085109e996a1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f72a1ddbced1016b9804320c8affd47919efa48bc8c3ec9beb2975e66ebcc6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "16c203c632e322567f8ce932652b5ff785302f4bb6623f01fc4e935ea0583d9d"
    sha256 cellar: :any_skip_relocation, ventura:        "c564cf5d48edcaab9c2940d0820bc420b5c99621d359a2b681c7b3e68e413843"
    sha256 cellar: :any_skip_relocation, monterey:       "fec981eff597fa04d969914104bc997bebe8858f2bfaf5ec532910295ca43167"
    sha256 cellar: :any_skip_relocation, big_sur:        "7562a49bdaa12d85af55aa8843379179dbfd78d9d8d44f14b481ca22760d4df6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0aa6fe3ae7b295e016e05dd3ceefe4056166f9ce7b9f8633c14345106a135f84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8c2ea435fa7ee838cc3fa07684b4f1b68ac5f65a224c7b5860b5bf06d254f50"
  end

  def install
    system "make"
    bin.install "dylibbundler"
  end

  test do
    system bin/"dylibbundler", "-h"
  end
end
