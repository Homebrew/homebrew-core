class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "420333968cbd5664b1a47202c3d78ad47b3cec692a140dd80185020467effd48"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1161a0b49834c41ad189ce48e89a1345dff800882525d13d28285d009a45dd60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "605cf77cce856e4ab9bc3211b83c397d33f91cb3028c5315dc319afc602fc568"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1eb636693cecbeabba04676bd5633e7bfcb6256643366c57570c527da17d024"
    sha256 cellar: :any_skip_relocation, ventura:        "aeb965c19643f4ced0acd2397d397065b03bb85defe3aeb20e822b18124230d5"
    sha256 cellar: :any_skip_relocation, monterey:       "c3647ff97d67d005795be4f14940e42ea64cf3669598c1bad14c6e01c02c8086"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffb2928f7a9e40a92703b16a0781e3d87c2d2fa0989b5de105537a750cd72752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49c7cc06ab30151ce4340e75eff3062b7c777e5cb6434044861d14d69590e14b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
