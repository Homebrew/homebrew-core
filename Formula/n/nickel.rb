class Nickel < Formula
  desc "Better configuration for less"
  homepage "https://github.com/tweag/nickel"
  url "https://github.com/tweag/nickel/archive/refs/tags/1.2.2.tar.gz"
  sha256 "11f9e8820f211241a95341667c786556a0271cf828246ac33d071929089dd97e"
  license "MIT"
  head "https://github.com/tweag/nickel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c8599159ccf7b1ddd5c3119486319095b9e2f1e08d32a6931ad433ef5c78e3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "259bb681daaf8725f27a58c6fad811a95a71ef412055b5d467456c3d495c156c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "434990ed67367f68e97046dadc16dd271dbdf27fa5c463340fa0d28a37f14765"
    sha256 cellar: :any_skip_relocation, sonoma:         "60b3cc0b878d7a4d4638f0fb70520c79b30db81cd3b5b7f58b1dee240f3d9581"
    sha256 cellar: :any_skip_relocation, ventura:        "fe32c49c9170e43f5abc5c7d462cf6e0706fad8074111330da040603459f39de"
    sha256 cellar: :any_skip_relocation, monterey:       "91fac04b5f6971ca5fc8cfa8ce01237ceccd73cbfcf065830b27ac691481e53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99afeade9178396042f682d0f7c9c17e37b27c08f082d7876103126aaa5c0162"
  end

  depends_on "rust" => :build

  def install
    ENV["NICKEL_NIX_BUILD_REV"] = tap.user.to_s

    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_equal "4", pipe_output(bin/"nickel", "let x = 2 in x + x").strip
  end
end
