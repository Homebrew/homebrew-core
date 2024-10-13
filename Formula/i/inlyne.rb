class Inlyne < Formula
  desc "GPU powered yet browserless tool to help you quickly view markdown files"
  homepage "https://github.com/Inlyne-Project/inlyne"
  url "https://github.com/Inlyne-Project/inlyne/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "5ef5b54f572d93e96fc9bb0621c698098d4c6747d1ccdda4bd95af4f0b988b80"
  license "MIT"
  head "https://github.com/Inlyne-Project/inlyne.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7056568b68182c6c19157e720aebba6b36b087d2ec4d2b877dc35137889f1717"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "795b49b70f6791d35eacf4f8cc5d7ce33fbf6e29de86cc09c331b9919b3f7c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a1bd6b797573bcb83ce72dfe79e6310404910b593c63be8d7bbf90268bc685c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ff421f43c095b86b55de237be33d739ca2509420dad914daff591147ac3d849"
    sha256 cellar: :any_skip_relocation, sonoma:         "cfa5319173f6ee8ec5d80acd001f8ae1b764db1b3b6096d4a7cde527070b2696"
    sha256 cellar: :any_skip_relocation, ventura:        "97cbbe8e9fea277396d4ad34e9ef1faa527ec89b284bf87495f9cb8208c0565b"
    sha256 cellar: :any_skip_relocation, monterey:       "0c148c1c99fa14a56d0e4c8ebddd0e21000dca044577aa21633923aae552b36a"
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
