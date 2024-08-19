class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.60.tar.gz"
  sha256 "f7096aa6b82adcc00fd2a771c1f404034250451a90dbdfdebb0d13a1ace98518"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba84dd0c8288486347873494dae4f4c7895bab24b8ede021ee291e914a21dd13"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "baae78b01223ff7a9c3fd85f07eff197ee39cb0b9b9f97663e8efcea73ac5cac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffe9499055c73ee29a5a17ece37a9bb060dffcae236f72b0dba39cf9ea85fe9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa35e0d31ae05b05abb67d5f6cc996b05f17a87ea52d78e795a4d9120f3de82a"
    sha256 cellar: :any_skip_relocation, ventura:        "da239477f3829c9018dbdb8144235ca5f0d31c1b53c0f046940d8792dfee0624"
    sha256 cellar: :any_skip_relocation, monterey:       "eb526e9e8f5fdc9804637a01f5f93ab42421501a9c605aa87ed4aa1ed929aaa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f80b0ef5a3431ceeee78fac7b0d0d23dffd2bb78b4aaffa9f816b7c6fc2092d7"
  end

  depends_on "rust" => :build

  def install
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec/"erg"
    erg_path.install Dir[buildpath/".erg/*"]
    (bin/"pylyzer").write_env_script(libexec/"bin/pylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath/"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end
