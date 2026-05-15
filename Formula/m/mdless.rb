class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.65.tar.gz"
  sha256 "a22222540685a4f973ad6b8739c2b6f576ff3537e42f0370819cc9f3fffef49d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cf16453b58d21154b5a3715b4f2b7c3627ab7d17b2f9e6cd977a76ca83eee64"
    sha256 cellar: :any,                 arm64_sequoia: "012c94f712e72a9adfbc0b7b812c6d7e57f8e36f039cc65d63f85e9a3c55bab6"
    sha256 cellar: :any,                 arm64_sonoma:  "783902b6ce58aaccaf249859483e9eeefcac6e0548653af05cba8cd6108951f8"
    sha256 cellar: :any,                 sonoma:        "82e566d65f4610b2a4f451675ba00cbd2df7b756bed2be15f9a6bf9a9e4e7493"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e49abff2805c4b46de61434fbd1c4f2647881e5b9dcb97119b9afa5b100dab66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18f8a5c0d2ae98e656ae881c66a8276d5ef014f51070826eb37f0227f75bb7f4"
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
