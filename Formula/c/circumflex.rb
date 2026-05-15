class Circumflex < Formula
  desc "Hacker News in your terminal"
  homepage "https://github.com/bensadeh/circumflex"
  url "https://github.com/bensadeh/circumflex/archive/refs/tags/4.1.1.tar.gz"
  sha256 "c5900e13c41d2e5a1da2d45e0d63b38d345dca584edfbf8e60b4daa7cda88cae"
  license "MIT"
  head "https://github.com/bensadeh/circumflex.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "82a4d31a5eb00cf571a421d8ad04afe3bba3a61a3d2488e37ab6ce165dcf7777"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82a4d31a5eb00cf571a421d8ad04afe3bba3a61a3d2488e37ab6ce165dcf7777"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82a4d31a5eb00cf571a421d8ad04afe3bba3a61a3d2488e37ab6ce165dcf7777"
    sha256 cellar: :any_skip_relocation, sonoma:        "7acb0988fa0e0e38e9b99eaf036e3027126bff2830981330ef33ea503272936f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7a0c4809eb6ae9f352745078e68639baaf561635b4df4519497beec0d377710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "266a0692420b33841d22f764b43f2b1eb28a9b6ec9adfe72a4b5178c1a82f6b4"
  end

  depends_on "go" => :build
  depends_on "less"

  def install
    system "go", "build", *std_go_args(output: bin/"clx", ldflags: "-s -w"), "./cmd/clx"
    man1.install "share/man/clx.1"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    config_home = testpath/".config"

    assert_match "Item added to favorites", shell_output("#{bin}/clx add 1")
    assert_path_exists config_home/"circumflex/favorites.json"
  end
end
