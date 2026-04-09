class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.64.tar.gz"
  sha256 "ff8d3871f1e6cbf35b42f2a3e351bae19346308d439db415ebca97607b8e1785"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2e15d3457eb2eb72eb967997d4a469053d9d23070fbe7a9d0c753f963bf92e38"
    sha256 cellar: :any,                 arm64_sequoia: "2a41c571cd757cd951038754dd43b1549dd4815d356d22909eb62e14f71ed543"
    sha256 cellar: :any,                 arm64_sonoma:  "1d9e64555e9ac765abcdff1b00df3724b56ee218ae4a5eaba024e0e25f25d185"
    sha256 cellar: :any,                 sonoma:        "e83951822a69a2e345235e86b7376dcf9238e90d7f470769f6ac4d38abb78607"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49ef59639132d021538bef1bc9b2b9667341a25c7b78d64c543cc12a4a6babab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9aebcc7a285c2727d227549891da0bbde337b1dcc8e746df0e1d83623171ce4"
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
