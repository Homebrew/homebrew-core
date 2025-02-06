class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.57.tar.gz"
  sha256 "5b69b0f6fa5c3560c4880bad69cb041441e3bc3bc1b143e8dce560c9a356ef0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a8e379204cbf447b3fbaecdd667d6c826c56f03048074b716af7271ce9b63ee"
    sha256 cellar: :any,                 arm64_sonoma:  "fc897a7dd9c1d16325dcd15aeca67ba9f958cbe1180a92be997abd2a641d0971"
    sha256 cellar: :any,                 arm64_ventura: "8aebcf8444a2e122088dd17ad8dd04f21cb2602ea293e2cfe912bfbf0e607058"
    sha256 cellar: :any,                 sonoma:        "0f6af97b160b52af2d7fb56c21cf03c293b4647dfbc6aead5108169dbd5738cd"
    sha256 cellar: :any,                 ventura:       "43e2df37cbce0b19746c9dce38b9f511ea97f072f55a334d108371ad6b41886c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f025b184eef27d126b196a0821b15f966c0e089b210ea45e1b03e034049b9a11"
  end

  # Requires Ruby >= 2.7
  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}/mdless --version")
    (testpath/"test.md").write <<~MARKDOWN
      # title first level
      ## title second level
    MARKDOWN
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end
