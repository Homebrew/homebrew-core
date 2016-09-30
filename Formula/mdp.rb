class Mdp < Formula
  desc "Command-line based markdown presentation tool"
  homepage "https://github.com/visit1985/mdp"
  url "https://github.com/visit1985/mdp/archive/1.0.8.tar.gz"
  sha256 "e9a366afac877e86d2dbc8d9ca3585138b8208581079b44c94000300a8b1cf81"
  head "https://github.com/visit1985/mdp.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c619dac68ee38987974a40424af26dbeb083a2094a63801f369ec4ec3f14a87" => :sierra
    sha256 "a38709f3da071c6e8becb2e94ba91c0261651b8de44d4e1d8781bc6554da8bc1" => :el_capitan
    sha256 "3d0bbee087458a4312a78d6a36e30a2a0b30711d35f07f264bf3e0999d0ca5c4" => :yosemite
    sha256 "f0c315c1a437ce4c220c4fb85c7e7234dd58b9c5929839202a13390d10d0e868" => :mavericks
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "sample.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdp -v")
  end
end
