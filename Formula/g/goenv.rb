class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.38.tar.gz"
  sha256 "ec22b8ca7f869f67e657fe6a2155e3fd1407a364429bdbaf04bb3daf33e12aeb"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d21c7170f8e183cfe24327e6c1439d20ca5faaf4dfbb26e12af4e6b6986c448f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d21c7170f8e183cfe24327e6c1439d20ca5faaf4dfbb26e12af4e6b6986c448f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d21c7170f8e183cfe24327e6c1439d20ca5faaf4dfbb26e12af4e6b6986c448f"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4c4c6446bde9d0afb8a348c6af67d4f6848eb1b0aeaf4bfda78342f31ec77bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d21c7170f8e183cfe24327e6c1439d20ca5faaf4dfbb26e12af4e6b6986c448f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d21c7170f8e183cfe24327e6c1439d20ca5faaf4dfbb26e12af4e6b6986c448f"
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
