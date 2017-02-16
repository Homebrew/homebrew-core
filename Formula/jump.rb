class Jump < Formula
  desc "Quick and fuzzy directory jumper."
  homepage "https://github.com/gsamokovarov/jump"
  url "https://github.com/gsamokovarov/jump/archive/v0.9.0.tar.gz"
  sha256 "978ea7fbc9564eafc1d96760c70d642677a6acf66ad2d2764bdc0b3cc8242420"
  head "https://github.com/gsamokovarov/jump.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "579b3ceb9dfe1b58d84719f026c33459827a54f9d37760f451167cdfe3eb548f" => :sierra
    sha256 "aab4a39cb14e1ef8ead19d80d86599c0086da8922d3c1529553939b04f34f185" => :el_capitan
    sha256 "4be7d5c55ce79646d3088de17bb47e25a8a5778e30a8e039bf2b473db8300753" => :yosemite
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
