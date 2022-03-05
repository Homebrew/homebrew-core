class Braid < Formula
  desc "Simple tool to help track vendor branches in a Git repository"
  homepage "https://cristibalan.github.io/braid/"
  url "https://github.com/cristibalan/braid.git",
      tag:      "v1.1.5",
      revision: "ebb2c5c65a6d22ad85adac5f2e9d7d3aa0ae066f"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "680fa799b8d8b2f7f77574f7a62e489096cb174d77728a1b88f4a84e94b77d47"
    sha256 cellar: :any_skip_relocation, big_sur:       "0383392403f7924a8bbd09c08dfc0b28e4c147b98a21a66b63bf9a16ffca49f1"
    sha256 cellar: :any_skip_relocation, catalina:      "1bbb75422a511aec7e439e350d4d428ed900ad9b78a3979d691430836c92a62a"
    sha256 cellar: :any_skip_relocation, mojave:        "5e62988e4e3c52890e699afc017e62e24d42ff49560d6c41e425c2649096d28b"
  end

  uses_from_macos "ruby", since: :high_sierra

  resource "arrayfields" do
    url "https://rubygems.org/gems/arrayfields-4.9.2.gem"
    sha256 "1593f0bac948e24aa5e5099b7994b0fb5da69b6f29a82804ccf496bc125de4ab"
  end

  resource "chronic" do
    url "https://rubygems.org/gems/chronic-0.10.2.gem"
    sha256 "766f2fcce6ac3cc152249ed0f2b827770d3e517e2e87c5fba7ed74f4889d2dc3"
  end

  resource "fattr" do
    url "https://rubygems.org/gems/fattr-2.4.0.gem"
    sha256 "a7544665977e6ff2945e204436f3b8e932edf8ed3d7174d5d027a265e328fc08"
  end

  resource "json" do
    url "https://rubygems.org/gems/json-2.6.1.gem"
    sha256 "7ff682a2db805d6b924e4e87341c3c0036824713a23c58ca53267ce7e5ce2ffd"
  end

  resource "main" do
    url "https://rubygems.org/gems/main-6.2.3.gem"
    sha256 "f630bf47a3ddfa09483a201a47c9601fd0ec9656d51b4a1196696ec57d33abf1"
  end

  resource "map" do
    url "https://rubygems.org/gems/map-6.6.0.gem"
    sha256 "153a6f384515b14085805f5839d318f9d3c9dab676f341340fa4300150373cbc"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      next if r.name == "json" && MacOS.version >= :high_sierra

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
