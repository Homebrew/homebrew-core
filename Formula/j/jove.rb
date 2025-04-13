class Jove < Formula
  desc "Emacs-style editor with vi-like memory, CPU, and size requirements"
  homepage "https://directory.fsf.org/wiki/Jove"
  url "https://github.com/jonmacs/jove/archive/refs/tags/4.17.5.3.tar.gz"
  sha256 "ca5a5fcf71009c7389d655d1f1ae8139710f6cc531be95581e4b375e67f098d2"
  # license ref, https://github.com/jonmacs/jove/blob/4_17/LICENSE
  license :cannot_represent

  bottle do
    sha256 arm64_sequoia:  "b90d580ff61490eff7f6032cc91842fa5d2c89a75ec2d3941ea12293bd7f3ea7"
    sha256 arm64_sonoma:   "319ebbfa519908f368108b4f2b5840fc8bef0182d081167fa80daf2274e267d6"
    sha256 arm64_ventura:  "bdfb0a74c8674460b1aacfeebfab0d7c645b392bb171eb4bc3bf4e71213cae31"
    sha256 arm64_monterey: "a46f4789b7af164cd5154cda01dc75417012c92ad0edf97a0f2b445d247c46d7"
    sha256 arm64_big_sur:  "cbe5d7e4fad45ad2e41d97206a79b12cf3ceefb33bb8839490fdfeb2b549603a"
    sha256 sonoma:         "042b38395d8adbb36ca33a01c061aa3b7f2fe54ed1c68b19f97d84571ba41b06"
    sha256 ventura:        "9422961e8614d8aec5478e85d35182ee89349d3c36f6f2532408840b7e7a26ff"
    sha256 monterey:       "7c883664ebb4fe5f42eef3a0df73ff285a3cb3e0e5f65f5a1c00b339b6523e7d"
    sha256 big_sur:        "7683237862192a39be911ad6fe74a44f39f84c0396b4c0d7c8d852c4e77745ae"
    sha256 arm64_linux:    "125a6a64781b69250f67e0569caa439193ffae01aa9a3ce5c4dfb2e0730cfd4e"
    sha256 x86_64_linux:   "5fa082ebb4156da6e11e7618f2aa658c30e6d80215093c913fc00a02489fb027"
  end

  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff" => :build
  end

  def install
    bin.mkpath
    man1.mkpath
    (lib/"jove").mkpath

    system "make", "install", "JOVEHOME=#{prefix}", "DMANDIR=#{man1}"
  end

  test do
    assert_match "There's nothing to recover.", shell_output("#{lib}/jove/recover")
  end
end
