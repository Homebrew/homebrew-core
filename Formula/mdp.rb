class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.7.tar.gz"
  sha256 "0299f43d7de8540fd0b7f5176d33ec2c7a9838e543e86c556a78b7a801de8b6f"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "08baaf77c3a11bbcf1193956fc004f437b01ec10721f649059ad2bcab9acd44c" => :el_capitan
    sha256 "1e1b20c31624cf8c21c6ac41ae1b4acfd1eb8c602bb2e5b459d1c8151dc16ac5" => :yosemite
    sha256 "640381a2570d9ad833d26fd955240a6e5024e1c8b0309e748adafbb0ff56b643" => :mavericks
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
