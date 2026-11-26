class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.70.tar.gz"
  sha256 "5ac948be56777e861fed3230b16b6c8741eb81fabe60d681fbc592f7bdee5b48"
  license "MIT"

  bottle do
    manifest_sha256 "2488691c2b07d79bf51adf025752ed959501ca22801251c97ef5e5ab7e1177f3"
    sha256 cellar: :any, arm64_golden_gate: "583f02a0e2ebd8e0541a921a0c08308696aade5375475ea143e8dde3d817359c"
    sha256 cellar: :any, arm64_tahoe:       "fa3415b714f359a971d170ea7fd45273344b04ab29c78f7541639f6b19231890"
    sha256 cellar: :any, arm64_sequoia:     "f3a83124031476c39c8e26b820be47f8c132a95859b9b07a74c014a45ee2ca73"
    sha256 cellar: :any, arm64_linux:       "d4c774ddb221547726631c3fae27ce44dd4b921b032fe2bc45ce122da3dd17f2"
    sha256 cellar: :any, x86_64_linux:      "2aff47c0897112efbe7b34a1356d58540961dc8c4b88202a7ebcaa040baf7725"
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
