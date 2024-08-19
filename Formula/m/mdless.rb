class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.44.tar.gz"
  sha256 "baa3df2a641f5f8646c90d955a1a89cee1e21aa3a571cbcbe6b45ee0df3189ea"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ccdc2729ca43fd97d8e4dc882e7f314cf1d45de14e92a80c69a0a781f6bd253"
    sha256 cellar: :any,                 arm64_ventura:  "7d342f3e5ad4e71f71155efc4938a79773518e0a8bcc1a1d1a001d06df3fcaf7"
    sha256 cellar: :any,                 arm64_monterey: "969bb90dd5b86447f06c4bd962a5109ed426bf39af4a4ce2c3a3a7a07b08b7d4"
    sha256 cellar: :any,                 sonoma:         "444d16e225ff1877acdebc31cdec07ddc0ccbe24437de8ed426243608218cc8e"
    sha256 cellar: :any,                 ventura:        "a63754351ae37b608126a64e2606e83fb0288bedcf3dcc9632e2517002ae83ea"
    sha256 cellar: :any,                 monterey:       "c6ef26ef7ce2273b82f7eb9c285afd60cf3acac45f8060601ecbfbb0ed78ae58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe5e2745792e8ebb94c8e653747813d3763ca981f474c6a5b0f1661dd5bf31ef"
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
