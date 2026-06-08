class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/2.1.65.tar.gz"
  sha256 "a22222540685a4f973ad6b8739c2b6f576ff3537e42f0370819cc9f3fffef49d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "733694816cac5a4bed49cf91e049f5911ded82131bba7ae4451ea17833734c22"
    sha256 cellar: :any, arm64_sequoia: "d6f5bf68f38f16e596e13ff0152ee1b15d77184ca98855e968db16848cd4a95e"
    sha256 cellar: :any, arm64_sonoma:  "c424b2b4f78e499b4c6bf06c4b851da7cb69554348f1c39e3910534de9aedeb5"
    sha256 cellar: :any, sonoma:        "c7a19e5be31e73a70ab9fe42e366110a5be053d38b0f11350ad973a8ca92108b"
    sha256 cellar: :any, arm64_linux:   "88332f86c1ced71f3930e33d57c429bd558ba3eb9bf9d40ae09f3f6cd161f929"
    sha256 cellar: :any, x86_64_linux:  "a80d5d8c840dfd6825a15cafccbe993951c280eab99b2a063ada330e786ddd41"
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
