class Braid < Formula
  desc "Simple tool to help track vendor branches in a Git repository"
  homepage "https://cristibalan.github.io/braid/"
  url "https://github.com/cristibalan/braid.git",
      tag:      "v1.1.10",
      revision: "16729390a2a8e6b45919545b056a1a7ac83c14d6"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf994c891b0d901bceab7e31c21b326527f158a9d919c7d763d5f5a25844e6ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf994c891b0d901bceab7e31c21b326527f158a9d919c7d763d5f5a25844e6ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cf994c891b0d901bceab7e31c21b326527f158a9d919c7d763d5f5a25844e6ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf994c891b0d901bceab7e31c21b326527f158a9d919c7d763d5f5a25844e6ac"
    sha256 cellar: :any_skip_relocation, ventura:       "cf994c891b0d901bceab7e31c21b326527f158a9d919c7d763d5f5a25844e6ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a30ac7001f8b4ee4cd78f913c580d432205a7bedf006ff557de41ae771f47dd"
  end

  uses_from_macos "ruby"

  resource "pstore" do
    url "https://rubygems.org/gems/pstore-0.1.3.gem"
    sha256 "04b6a7d299379277ac3ec110a1c99785d6596c2db8ae52b8b8c2de5b8c2ab3c4"
  end

  resource "ostruct" do
    url "https://rubygems.org/gems/ostruct-0.6.0.gem"
    sha256 "3b1736c99f4d985de36bde1155be5e22aaf6e564b30ff9bd481e2ef7c2d9ba85"
  end

  resource "map" do
    url "https://rubygems.org/gems/map-6.6.0.gem"
    sha256 "153a6f384515b14085805f5839d318f9d3c9dab676f341340fa4300150373cbc"
  end

  resource "fattr" do
    url "https://rubygems.org/gems/fattr-2.4.0.gem"
    sha256 "a7544665977e6ff2945e204436f3b8e932edf8ed3d7174d5d027a265e328fc08"
  end

  resource "chronic" do
    url "https://rubygems.org/gems/chronic-0.10.2.gem"
    sha256 "766f2fcce6ac3cc152249ed0f2b827770d3e517e2e87c5fba7ed74f4889d2dc3"
  end

  resource "arrayfields" do
    url "https://rubygems.org/gems/arrayfields-4.9.2.gem"
    sha256 "1593f0bac948e24aa5e5099b7994b0fb5da69b6f29a82804ccf496bc125de4ab"
  end

  resource "main" do
    url "https://rubygems.org/gems/main-6.3.0.gem"
    sha256 "ebd573133ab3707e2b43710de79f03bde7f10d41b86f2ba75e93da1482b04897"
  end

  resource "logger" do
    url "https://rubygems.org/gems/logger-1.6.0.gem"
    sha256 "0ab7c120262dd8de2a18cb8d377f1f318cbe98535160a508af9e7710ff43ef3e"
  end

  resource "json" do
    url "https://rubygems.org/gems/json-2.7.1.gem"
    sha256 "187ea312fb58420ff0c40f40af1862651d4295c8675267c6a1c353f1a0ac3265"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      next if r.name == "json" && OS.mac? && MacOS.version >= :high_sierra

      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end
    system "gem", "build", "braid.gemspec"
    system "gem", "install", "--ignore-dependencies", "braid-#{version}.gem"
    bin.install libexec/"bin/braid"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    mkdir "test" do
      system "git", "init"
      (Pathname.pwd/"README").write "Testing"
      (Pathname.pwd/".gitignore").write "Library"
      system "git", "add", "README", ".gitignore"
      system "git", "commit", "-m", "Initial commit"
      output = shell_output("#{bin}/braid add https://github.com/cristibalan/braid.git")
      assert_match "Braid: Added mirror at '", output
      assert_match "braid (", shell_output("#{bin}/braid status")
    end
  end
end
