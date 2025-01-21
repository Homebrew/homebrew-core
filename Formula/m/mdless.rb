class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.56.tar.gz"
  sha256 "9ff7e6b32c719407ee13f7f6f85eabc5589edca159d6cf666cd31f95ebd223f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "10d4d3857e093cb31582d0845688eb80b6e446ecbaba64335683d90c23272906"
    sha256 cellar: :any,                 arm64_sonoma:  "f747ed68b967bb69fe225e8083f67d836880377f10ac2bc1629e03fcec66de8d"
    sha256 cellar: :any,                 arm64_ventura: "ca06a7d9949eede27ac20240ffe82ec97b681655dc7113c46a3957df8520d7cd"
    sha256 cellar: :any,                 sonoma:        "e4792beb1c6c7d26c39aa5e66129f98bc7a51200877778a0798ac30fa3c0f2c3"
    sha256 cellar: :any,                 ventura:       "52e9034713bc44d11fe034a0c4a4c5fe15c9d9ecb63725c59a0f0e8e18f6225b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f348d375c91e45152a2c044d46060805ec0e721f496d3480e5be67180f06001"
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
