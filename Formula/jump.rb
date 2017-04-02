class Jump < Formula
  desc "Helps you navigate your file system faster by learning your habits."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.11.0.tar.gz"
  sha256 "e3f7f6640fe13f5b482bbbfdd73a133d361d1304d6fb8aee9b45b0875f6b478b"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5fda77713765473962846a6e0f0008f513a5c8f721454c0359f9dc0507cde2cd" => :sierra
    sha256 "3c94a87b004898da69d61938ddef4c91efe3898b73e2e8206a9d92aac1a9a1df" => :el_capitan
    sha256 "fb9d270d57a917fd51fe24cd67cd1a1842341e9ac017b49335f1e6a148bab005" => :yosemite
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
