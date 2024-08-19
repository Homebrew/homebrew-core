class Jbang < Formula
  desc "Tool to create, edit and run self-contained source-only Java programs"
  homepage "https://jbang.dev/"
  url "https://github.com/jbangdev/jbang/releases/download/v0.117.1/jbang-0.117.1.zip"
  sha256 "28b66273d5ff4057ed37a2dfda5b49b549768e8bed6e0ea335015eea8d28c67c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ab784d8fb46f220d5b9d2efc2f808d5ee3fe7157e00e4aa1b4bdbacaf9c1ae4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ab784d8fb46f220d5b9d2efc2f808d5ee3fe7157e00e4aa1b4bdbacaf9c1ae4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ab784d8fb46f220d5b9d2efc2f808d5ee3fe7157e00e4aa1b4bdbacaf9c1ae4"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ab784d8fb46f220d5b9d2efc2f808d5ee3fe7157e00e4aa1b4bdbacaf9c1ae4"
    sha256 cellar: :any_skip_relocation, ventura:        "8ab784d8fb46f220d5b9d2efc2f808d5ee3fe7157e00e4aa1b4bdbacaf9c1ae4"
    sha256 cellar: :any_skip_relocation, monterey:       "8ab784d8fb46f220d5b9d2efc2f808d5ee3fe7157e00e4aa1b4bdbacaf9c1ae4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b6d07e4a603a02d26232d82e5ea9d28c74d418b4594aaa83ca2306b19d4a3e"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    inreplace "#{libexec}/bin/jbang", /^abs_jbang_dir=.*/, "abs_jbang_dir=#{libexec}/bin"
    bin.install_symlink libexec/"bin/jbang"
  end

  test do
    system bin/"jbang", "init", "--template=cli", testpath/"hello.java"
    assert_match "hello made with jbang", (testpath/"hello.java").read
    assert_match version.to_s, shell_output("#{bin}/jbang --version 2>&1")
  end
end
