class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.68.tar.gz"
  sha256 "e7fa23436f97f03f141d5fed8f8c8b178e56a9c2712574b7dba7988f64e7d171"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "156938662d3caa5020cbbfd92a8c4ec479dbf5df4c8a3cf38e41ce83b9a7c837"
    sha256 cellar: :any, arm64_sequoia: "394d89b8c5980274665df2b875f0754340e62104def5417dbc78e49ba89b1567"
    sha256 cellar: :any, arm64_sonoma:  "273a684e3ca1e912d8e157ba1a7dd8bc462b2307ccb51887ff6f9443e3e22578"
    sha256 cellar: :any, sonoma:        "1061c553b4bc28eeaac83eec95fc52657adaf3483b6be139e27ea84aadf18f73"
    sha256 cellar: :any, arm64_linux:   "ecda127eb6855bc168af73b595fd21e1465b3dce9a12ca7a4996d4bce3b9da23"
    sha256 cellar: :any, x86_64_linux:  "22f57dbae96b5f24e0b480ca5498325b3694aabad7145d3a2ab7c22733f883c1"
  end

  depends_on "ruby"

  # List with `gem install --explain mdless --platform ruby -v #{version}`
  resource "tty-which" do
    url "https://rubygems.org/gems/tty-which-0.5.0.gem"
    sha256 "5824055f0d6744c97e7c4426544f01d519c40d1806ef2ef47d9854477993f466"
  end

  resource "tty-cursor" do
    url "https://rubygems.org/gems/tty-cursor-0.7.1.gem"
    sha256 "79534185e6a777888d88628b14b6a1fdf5154a603f285f80b1753e1908e0bf48"
  end

  resource "tty-spinner" do
    url "https://rubygems.org/gems/tty-spinner-0.9.3.gem"
    sha256 "0e036f047b4ffb61f2aa45f5a770ec00b4d04130531558a94bfc5b192b570542"
  end

  resource "tty-screen" do
    url "https://rubygems.org/gems/tty-screen-0.8.2.gem"
    sha256 "c090652115beae764336c28802d633f204fb84da93c6a968aa5d8e319e819b50"
  end

  resource "rouge" do
    url "https://rubygems.org/gems/rouge-4.7.0.gem"
    sha256 "dba5896715c0325c362e895460a6d350803dbf6427454f49a47500f3193ea739"
  end

  resource "redcarpet" do
    url "https://rubygems.org/gems/redcarpet-3.6.1.gem"
    sha256 "d444910e6aa55480c6bcdc0cdb057626e8a32c054c29e793fa642ba2f155f445"
  end

  resource "logger" do
    url "https://rubygems.org/gems/logger-1.7.0.gem"
    sha256 "196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies", "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"
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
