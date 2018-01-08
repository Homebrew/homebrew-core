class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.18.0.tar.gz"
  sha256 "68d520d2aa67981e8f59a70cec24137375ed0bd757fa8d44e670efbc21b7a2c6"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df2993124ca8f2eab3739f59040993a27c6ac634c9ac3899cb77022c076be1ca" => :high_sierra
    sha256 "5d0ff67b1a1bb2fdd122c7f3dfca711e06bfed309e1326c7e3dc1449aa7fa1b5" => :sierra
    sha256 "16f4049d86aab91e8588fae8aa0e80f13269f771d5a3a2962ec7856eedd1a8b0" => :el_capitan
    sha256 "d0b66701e81ed141719935171c6e52325191a73545f8d808fe082cbc2c1613ca" => :yosemite
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
