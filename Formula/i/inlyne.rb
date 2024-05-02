class Inlyne < Formula
  desc "GPU powered yet browserless tool to help you quickly view markdown files"
  homepage "https://github.com/Inlyne-Project/inlyne"
  url "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "f454581844f48fbcc9dcb769e607cae768ed9070baea03fb31b1fa8064b45d7c"
  license "MIT"
  head "https://github.com/Inlyne-Project/inlyne.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa900a5c1ee938d9652a354e5032a64edd4a795373c8a217e056444005f349d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78d2b141bc9bfc43731e7a66e65c1ea8f8f4115b28a351442fcb86cb54df054b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ca14b5cea4bfd5ae7f1e3c3f839292670b92466ef9ab1276d2865e6bf389d2b"
    sha256 cellar: :any_skip_relocation, sonoma:         "817345580436541a81897180e423dbfa8de52b8c1e4d2168e14b3c4618cbb3a6"
    sha256 cellar: :any_skip_relocation, ventura:        "cd9630e5a0402ea0aaa17754fead8f7c0e616c495cdaf5bd314c609ecef4afd5"
    sha256 cellar: :any_skip_relocation, monterey:       "d21cfcf5ad2d7e6fd62eca897c1608f1fce5f5c9bfc3f9c51badf8f2687ec6c8"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on :macos # currently linux build failed to start, upstream report, https://github.com/Inlyne-Project/inlyne/issues/263

  uses_from_macos "expect" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_markdown = testpath/"test.md"
    test_markdown.write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS

    script = (testpath/"test.exp")
    script.write <<~EOS
      #!/usr/bin/env expect -f
      set timeout 2

      spawn #{bin}/inlyne #{test_markdown}

      send -- "q\r"

      expect eof
    EOS

    system "expect", "-f", "test.exp"

    assert_match version.to_s, shell_output("#{bin}/inlyne --version")
  end
end
