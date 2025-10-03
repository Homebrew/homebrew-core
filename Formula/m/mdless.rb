class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.62.tar.gz"
  sha256 "1819b0b082b6cea95be542e39828b3ced344334bcfe62a318df71386518d07a6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7fdbd007a51aceeccf6ec8d24e419d4fa6fa89f9884fe6aef6e7b2ad6f8ea17"
    sha256 cellar: :any,                 arm64_sequoia: "2f685489abc329323095d92133a0dcd31441d10307f0474bbb4413b53d2274b7"
    sha256 cellar: :any,                 arm64_sonoma:  "0592587133ab75b44b46fbf957856c047ba3e1ee2109c1b26053c87d6f64ff29"
    sha256 cellar: :any,                 arm64_ventura: "fa86f8095663d1c7d4a8f925133a5ef316fd37dc9137c7a1de6095fe9ebc0a1d"
    sha256 cellar: :any,                 sonoma:        "8f1f01fbd37167238a0ea1619d6adf3ba541a2284a9922939d74364bec043da0"
    sha256 cellar: :any,                 ventura:       "5664722266afd9637e16601f148ed0b02a4bb8340d5c6a70a1ca1e004b558d34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dd44adf15bc57b0f13d299b49282f0cf9aa3ca90c58e14db93598d3fb7243af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "851c4c16ebee885c363fd057e77d06e88dbea21ff49bf59a573d29b47ec1a0bf"
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
