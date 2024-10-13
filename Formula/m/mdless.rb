class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.48.tar.gz"
  sha256 "e19e9396c88a345e5599465a24ccedf4f0a45a09d96b4f32ebe9376d8a1a73d6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1451017f727c91e915545eea5cfc801e0bcd35acbaaab9f1449053cae61c7dbb"
    sha256 cellar: :any,                 arm64_sonoma:  "1f5f17c23bbf67aa0c65b7dd21628ba8453f9b09c0957cd23471f8eede9482f8"
    sha256 cellar: :any,                 arm64_ventura: "96726ed0918b680495010aa154320415f7476f62017cc89fc5d28f9c9a8f0636"
    sha256 cellar: :any,                 sonoma:        "48d7d51fdf66617debfa9b9e6763323ebd3ebe2dab6b35dbef39a3e1be219c96"
    sha256 cellar: :any,                 ventura:       "30f9b25c1c1c4851a809d940bd4d9a7bef6b224f6a43fd4196b4da2e926cba56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4543136bc75d1293d70fd9e4756c25c67efb4296fd67e5c5f82b44c1aee0bb99"
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
