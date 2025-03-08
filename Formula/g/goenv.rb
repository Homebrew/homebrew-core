class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.21.tar.gz"
  sha256 "23566b4f09c1098c6a35668d31eb1ed4dec420040a8b4a4be158f08fecd760a7"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "620a44446ea429170d0a727d62a27e9fa5c5497562cd1c09bc7ffcbef4cb68cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "620a44446ea429170d0a727d62a27e9fa5c5497562cd1c09bc7ffcbef4cb68cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "620a44446ea429170d0a727d62a27e9fa5c5497562cd1c09bc7ffcbef4cb68cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc873f09b23dec8329c771af38ca34de91f5bf79d145cae82fe8d78c5fb572fe"
    sha256 cellar: :any_skip_relocation, ventura:       "bc873f09b23dec8329c771af38ca34de91f5bf79d145cae82fe8d78c5fb572fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "620a44446ea429170d0a727d62a27e9fa5c5497562cd1c09bc7ffcbef4cb68cb"
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
