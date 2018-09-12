class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.21.0.tar.gz"
  sha256 "27a5cf4f48164806bd1ed6c33cf014368db8c0250a1b7f0fb6fe55827dcbaf18"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9736821da1fb38d78d6a929f81a1df81d24dd2b1c6731b8ace9dd28a78c5876" => :mojave
    sha256 "50a516dd7eeb10a2234772ded9b818e45ccebbf880d06d70b569b7cd48725d87" => :high_sierra
    sha256 "0b902ba49493c1eb2b4221ef158bc9313aa040108da369fc488379d65e56fb9c" => :sierra
    sha256 "1a7872797c5f8b458696a71ac073fd142a71037bcf2c0a5d9c86d7685dfecd41" => :el_capitan
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
