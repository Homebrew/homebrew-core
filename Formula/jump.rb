class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits"
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.21.0.tar.gz"
  sha256 "27a5cf4f48164806bd1ed6c33cf014368db8c0250a1b7f0fb6fe55827dcbaf18"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "74316d2be4f5c013c6a7fcfed532391a205104dfe59eb44e2dd4cf5499675f26" => :mojave
    sha256 "bc2b9263678fb825075b4d7221418d92b8e497c15b4d8c59c0e73d4b73877809" => :high_sierra
    sha256 "36e8f4ad78dca0facb3ebd2023829c70046a667ad079d036b4084b5a2bad5930" => :sierra
    sha256 "c80701e56abf728f1ccd1e4a65c5161d94c6192e662bf81af3f9c9f8a80b3903" => :el_capitan
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
