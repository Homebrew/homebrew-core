class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/1.0.32.tar.gz"
  sha256 "ce67a184aaeba66955c96f9f2d3353040b359c166329a149c49b470bf8edeb39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "831ab133d0eadf0b5e2c718d06606c018b2cf29bc1dfb5d36fee2a8d5e7310c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "831ab133d0eadf0b5e2c718d06606c018b2cf29bc1dfb5d36fee2a8d5e7310c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c84c0fe0a30bf587a1f342bf0f5fde9b13df687364863d658ed10f66fa59895d"
    sha256 cellar: :any_skip_relocation, ventura:        "831ab133d0eadf0b5e2c718d06606c018b2cf29bc1dfb5d36fee2a8d5e7310c0"
    sha256 cellar: :any_skip_relocation, monterey:       "831ab133d0eadf0b5e2c718d06606c018b2cf29bc1dfb5d36fee2a8d5e7310c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "831ab133d0eadf0b5e2c718d06606c018b2cf29bc1dfb5d36fee2a8d5e7310c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7ebc6e459d02711eae96faa862f3738999534122dd9898c8bb1e62c2416f788"
  end

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}/mdless --version")
    (testpath/"test.md").write <<~EOS
      # title first level
      ## title second level
    EOS
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end
