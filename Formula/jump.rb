class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.40.0.tar.gz"
  sha256 "f005f843fc65b7be1d4159da7d4c220eef0229ecec9935c6ac23e4963eef645e"
  license "MIT"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a22ec459650a0e62e4ef082ddf29b1bb64cfd636fb696714107feb11efcace8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "526a1422ba30c6b9aa0451a7a4ffb1b19f49bb624e73b036c201ef5f2c762cfa"
    sha256 cellar: :any_skip_relocation, monterey:       "fae40c2bea2fb44649ce866c5f09146afd19fd4edb27476aba601d44e4844ed4"
    sha256 cellar: :any_skip_relocation, big_sur:        "82d744d63ad1485d1ef5afa534d9f1526339e217b86ba38f7e4e54afb3c7d439"
    sha256 cellar: :any_skip_relocation, catalina:       "a89cde1a3dd5671412c35dd53603349c1b76fa474be9349231c895e8e3c71b48"
    sha256 cellar: :any_skip_relocation, mojave:         "a877dfb7b7a806bb3637555125e91605c3e8834f53ca9d0d900693349d5f35f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78a7ce6dda5a72a3117fcdabe550a9eac8805b29837b93f85268a972c2221c2f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", "#{bin}/jump"
    man1.install "man/jump.1"
    man1.install "man/j.1"
  end

  test do
    (testpath/"test_dir").mkpath
    ENV["JUMP_HOME"] = testpath.to_s
    system "#{bin}/jump", "chdir", "#{testpath}/test_dir"

    assert_equal (testpath/"test_dir").to_s, shell_output("#{bin}/jump cd tdir").chomp
  end
end
