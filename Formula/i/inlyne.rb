class Inlyne < Formula
  desc "GPU powered yet browserless tool to help you quickly view markdown files"
  homepage "https://github.com/Inlyne-Project/inlyne"
  url "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "62e089627812690b182520138708151f47391c5ba518f0b80649942dedd1be87"
  license "MIT"
  head "https://github.com/Inlyne-Project/inlyne.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "730fe33a25ed35d4b6c18f6a261cd22694c2d0fd3500197e096a8c80ed4940b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc2b48205cff31cd9b27e7673128c9d535dad90d8e7e504c25e2682d55097977"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d85e6a38f9e52d4dbfdca433c231e9c7b374450241314653b3ab150eb32fa4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd8962eab6f061f2973ed475ce30e562e7972de59d76b8ba184520571fda9432"
    sha256 cellar: :any_skip_relocation, ventura:        "ebe2ecd3e53a9886453a5529b23d79d99b192e56fd759ecaa21f15d86aa0db8a"
    sha256 cellar: :any_skip_relocation, monterey:       "32882860363ad3a2f8d8ea2450e9da31a2b41bf8b0031b347c1e362d170356f8"
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
