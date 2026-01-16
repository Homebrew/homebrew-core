class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.62.tar.gz"
  sha256 "1819b0b082b6cea95be542e39828b3ced344334bcfe62a318df71386518d07a6"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11949a05aecb70154127649ab6e7fda3d75770269b197463b2bd33c0cb15402a"
    sha256 cellar: :any,                 arm64_sequoia: "303cd91620317c9db7361953e29f577071fc42722fb47d4bedb400dbb319c480"
    sha256 cellar: :any,                 arm64_sonoma:  "dd1ce5189df56da597ec02e41a0d96a403da92e7b4117b51a123c447a47a8a04"
    sha256 cellar: :any,                 sonoma:        "66a314542add622d3d1f6fb253dbde821f84e945baf86f4400c9962f4d326a7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "584bb364b3412bc3f864e1e634a5d130a3e253d0788d6a169994efd3d9b468dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76d804aca01c89a186456ef369cdf630cdf0bd84c436d6d25430c894adb1624f"
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
