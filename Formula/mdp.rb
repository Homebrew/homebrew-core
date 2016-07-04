class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.7.tar.gz"
  sha256 "0299f43d7de8540fd0b7f5176d33ec2c7a9838e543e86c556a78b7a801de8b6f"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0965317362b89a9bc27b5a47a270b17d7a11c24a359cd19602becfe8304c6a0b" => :el_capitan
    sha256 "5695074ce45e8dadfe1e93820c0fb820d081731836793375f311fa781a6c4032" => :yosemite
    sha256 "9cc33825f2e08d645067d4b696f6fcd71ea728e2d376d0a44a7c3e87a0b1b43f" => :mavericks
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    share.install "sample.md"
  end

  test do
    # Go through two slides and quit.
    ENV["TERM"] = "xterm"
    pipe_output "#{bin}/mdp #{share}/sample.md", "jjq", 0
  end
end
