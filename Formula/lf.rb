class Lf < Formula
  desc "Terminal file manager"
  homepage "https://godoc.org/github.com/gokcehan/lf"
  url "https://github.com/gokcehan/lf/archive/r19.tar.gz"
  sha256 "8808069021ee1c0012440edabdc239b9f58f36bdd44d27b07eae7c91b97afdef"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "496309156a027b573f6d73a3d7acb0e794ac03ecfde74a0b5a54c1fd158c3e15" => :big_sur
    sha256 "a388d6b2d666b774315ea2076903ba406798e12b25e6c965ee920f5104d9f6fa" => :arm64_big_sur
    sha256 "07775e12ccff3030f3ec36153cc98b96e63fe134d32ffd96de21083a4d4f4aab" => :catalina
    sha256 "4f476517105c8b84ede38445a56dbf9215ecae4b510eaf69fe0274eca2963b03" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.gVersion=#{version}"
    man1.install "lf.1"
    zsh_completion.install "etc/lf.zsh" => "_lf"
    fish_completion.install "etc/lf.fish"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/lf -version").chomp
    assert_match "file manager", shell_output("#{bin}/lf -doc")
  end
end
