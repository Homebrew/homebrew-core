class Jump < Formula
  desc "Quick and fuzzy directory jumper."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.10.0.tar.gz"
  sha256 "6826d353f9724c7dd417479fd9aea396d63463962e38682154964c07072a61fc"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb1b677d4264a79e2a9375eff786b3d31b2f8b0b6ee982870965a03bd6824ea8" => :sierra
    sha256 "aaa6488ff1bc746539cf4a7a9aa2007685b835085dc862724c0d2ee105b113c1" => :el_capitan
    sha256 "068aa3bcdf829f139f128f1faf9d423719af04f1b6b8e92656bb7b1abae11bef" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gsamokovarov").mkpath
    ln_s buildpath, buildpath/"src/github.com/gsamokovarov/jump"

    system "go", "build", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
