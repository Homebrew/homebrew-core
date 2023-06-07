class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.107.0/jbang-0.107.0.zip"
  sha256 "d295864c2ec0810e72dc3894ca6bc4559d2184e210d3659a4e59ce1513d504c6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2fb131865203dfcd18a6d0755eace835f50c4810d7db8641fc491fa71a05a6ea"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}/bin/jbang", /^abs_jbang_dir=.*/, "abs_jbang_dir=#{libexec}/bin"
    bin.install_symlink libexec/"bin/jbang"
  end

  test do
    system "#{bin}/jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read
    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end
