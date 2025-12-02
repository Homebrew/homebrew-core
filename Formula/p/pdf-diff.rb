class PdfDiff < Formula
  desc "Tool for visualizing differences between two pdf files"
  homepage "https://github.com/serhack/pdf-diff"
  url "https://github.com/serhack/pdf-diff/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "13053afc3bbe14b84639d5a6a6416863e8c6d93e4f3c2c8ba7c38d4c427ae707"
  license "MIT"
  head "https://github.com/serhack/pdf-diff.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "3109937918e55155cabbc7db5bbe153bf22cc27f0f315e13c8539ccf8cf94529"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "33b71b6dcebe2687113628450e3a414db0c5abc4c27b4eda4090477c089f102f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9880f5520ed55ad05c505196a7d9c826c1a9afebefd1c96b56d9f38fca232a6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe08862077f15673639f22904af5e0e6d3953e29f5df8b8a231b38f748e6af05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe08862077f15673639f22904af5e0e6d3953e29f5df8b8a231b38f748e6af05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe08862077f15673639f22904af5e0e6d3953e29f5df8b8a231b38f748e6af05"
    sha256 cellar: :any_skip_relocation, sonoma:         "a459eb490a382b87a8e0145910830ace8b8a736eea8c0ce3ed7d18c80ac92883"
    sha256 cellar: :any_skip_relocation, ventura:        "e8b0e6e652c67281398e49a6d61c2b8624c5ea7fb538771fc4b47ce50188a877"
    sha256 cellar: :any_skip_relocation, monterey:       "e8b0e6e652c67281398e49a6d61c2b8624c5ea7fb538771fc4b47ce50188a877"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8b0e6e652c67281398e49a6d61c2b8624c5ea7fb538771fc4b47ce50188a877"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "84cee2f29e043eacbe31386f0b25ec75558d4dd1971c627d71b4a5071ce5ae02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66929021a8898ca16128f0ed3b1fb9ffbc4ac8b5778bdb48259207c91daa64fa"
  end

  depends_on "go" => :build
  depends_on "poppler"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    pdf = test_fixtures("test.pdf")

    expected = <<~EOS
      Color chosen: 255.000000 32.000000 16.000000 \

      Image generation for: #{test_fixtures("test.pdf")}
      []
      Image generation for: #{test_fixtures("test.pdf")}
      The pages number 1 are the same.
    EOS
    assert_equal expected,
      shell_output("#{bin}/pdf-diff #{pdf} #{pdf}")
  end
end
