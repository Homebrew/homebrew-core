class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.16.0.tar.gz"
  sha256 "e16f3ec485793326c09f6b7096edacbb117fcbbd40341289e055ea19a5347033"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4eab4337efa2def339ada5c7e0d73329e1207be17b7b50be30914c3a9469f4c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "573e00b2cbdd6c13a681ee869e11836858463a27c777f60857ac369443d89117"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a52447f547ad8c46ae28dfad776ae1bf767c8bcf1d410a917bff27a1bc962be8"
    sha256 cellar: :any_skip_relocation, ventura:        "2bfccf2d9c186bb201c7ab7c7dbeaf3bb96e11a05e5f505dc0b890502177bf9c"
    sha256 cellar: :any_skip_relocation, monterey:       "fe590137419bb55a098b0d41cb52fdf5b51ff07d60985a5fed9d54989db5742e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c5106a821c50c9085f74fb8b148e0ccbbcc18652780d24124143032adb54b01"
    sha256 cellar: :any_skip_relocation, catalina:       "76e78832943bc4291d61de04f0dc362517e22d795e0438e9a4c9c0567fe00b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "724eaf6b8eb4c027d7b6d6bed22a5e51fc37dec9a5ee78b6f0d014caa57dc472"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://github.githubassets.com/images/modules/site/icons/footer/github-logo.svg"
  end
end
