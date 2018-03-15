class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.18.0.tar.gz"
  sha256 "68d520d2aa67981e8f59a70cec24137375ed0bd757fa8d44e670efbc21b7a2c6"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3aadaf3585a6385ead346e6aec41c860cb2324d03ca8e6d32bcb6b54258ffc06" => :high_sierra
    sha256 "86fc2255812cd798f7cb75a056e82a6284183a166a5c39abfa2bfcd1cb9042b8" => :sierra
    sha256 "72a0d85e9d7d205543a954d577e3187541476edeef02017730b823d2fcfe88ee" => :el_capitan
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
