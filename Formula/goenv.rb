class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/2.0.6.tar.gz"
  sha256 "ba4882cf34dd44b0d5349f0a2931aa672478a77fa64023874fc2cd1a52a15792"
  license "MIT"
  version_scheme 1
  head "https://github.com/syndbg/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91f85cc1957be391a24b241014f2d03c18ce8949f02e7dc9ee2b671c22687ecf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91f85cc1957be391a24b241014f2d03c18ce8949f02e7dc9ee2b671c22687ecf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91f85cc1957be391a24b241014f2d03c18ce8949f02e7dc9ee2b671c22687ecf"
    sha256 cellar: :any_skip_relocation, ventura:        "6b54b59c24c8a917a3f15ec22b36be5ff41ba72b616157fc17c1327d7ce0bc0a"
    sha256 cellar: :any_skip_relocation, monterey:       "6b54b59c24c8a917a3f15ec22b36be5ff41ba72b616157fc17c1327d7ce0bc0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b54b59c24c8a917a3f15ec22b36be5ff41ba72b616157fc17c1327d7ce0bc0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91f85cc1957be391a24b241014f2d03c18ce8949f02e7dc9ee2b671c22687ecf"
  end

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
