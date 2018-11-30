class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.22.0.tar.gz"
  sha256 "67d5239a5a187ae39a5b4e4fdbc0ce917db1d5384c34cd336e9f3cf95c436175"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1b3d072fc77dfdcf996a156b4aad18231d3eb6e4f60c30d36413b2e5fda2265" => :mojave
    sha256 "c4593b2d462f90e07de46f6ef3c10fb8acee00a86750ffac08ea00d909a9196d" => :high_sierra
    sha256 "aae48a7e31b328afbda4025af4356b86a5dd94fe9f0657ac681d7d882578da70" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gsamokovarov").mkpath
    ln_s buildpath, buildpath/"src/github.com/gsamokovarov/jump"

    ENV["GO111MODULE"] = "off"
    system "go", "build", "-o", "#{bin}/jump"
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
