class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.42.tar.gz"
  sha256 "c9f9a846eea7a6fdbbd82549197de1faee5ca84929a7d117202c2c774f6c262f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5cfc807befb1543428e53061bcee8ca8b20226905439f7874e80b68c760bc307"
    sha256 cellar: :any,                 arm64_ventura:  "9689e76d484216e991611d7d7ae2a892fea2de0550c46db9cd5d15380f7b0489"
    sha256 cellar: :any,                 arm64_monterey: "f0c93622ae62db99093f1d6c5801816e05988cdfee9e8ac6acea556795dab350"
    sha256 cellar: :any,                 sonoma:         "bdb322312b3996d1e3d20e4a9d9c061a63558b7c57b491c788ee5142bfcf8b02"
    sha256 cellar: :any,                 ventura:        "328146f19871b949f6ab90395985386b3ebff358f294745e2b271de1dec709c6"
    sha256 cellar: :any,                 monterey:       "aa19789c23893cb3422da1967404417eaf324bbaa9e6c6c024291e46572d7892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30a918fe7c00e25e7ec0e9341b39d0777fb587360039ee1767b52a6064ae64cf"
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
    (testpath/"test.md").write <<~EOS
      # title first level
      ## title second level
    EOS
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end
