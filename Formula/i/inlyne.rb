class Inlyne < Formula
  desc "GPU powered yet browserless tool to help you quickly view markdown files"
  homepage "https://github.com/Inlyne-Project/inlyne"
  url "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "62e089627812690b182520138708151f47391c5ba518f0b80649942dedd1be87"
  license "MIT"
  head "https://github.com/Inlyne-Project/inlyne.git", branch: "main"

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
