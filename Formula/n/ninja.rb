class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "8b2c86cd483dc7fcb7975c5ec7329135d210099a89bc7db0590a07b0bbfe49a5"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5a2ef2f378d5d7d558fb9f5cb6fa3e309b2c0c1c67ffd2ea74e8ae80a837622"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e69678106abab50387e74df653dd849e9dac4dbdc48eac56a7a0ea824b251468"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3cb72bae37caea3273847af247746cc0edd23b6857b377bab1ba827de39db66"
    sha256 cellar: :any_skip_relocation, sonoma:         "de33b883ec9582725647fa660df145a5a1344da0e0cf353a4b01ee2f30b73443"
    sha256 cellar: :any_skip_relocation, ventura:        "cb54706a0d2f0dc0c38de379b259907f4cec7d10a4b6c287111bdaa299bb0a0a"
    sha256 cellar: :any_skip_relocation, monterey:       "826bbce2795e00d4e7599f13962155a2a91d0a0d41ed3f6624b85c1fc9a68053"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9fd2856b2cb4481caa5ec502ba9f5ce8312543f1ea062e3e101eb7b2e38d304"
  end

  uses_from_macos "python" => [:build, :test], since: :catalina

  def install
    system "python3", "configure.py", "--bootstrap", "--verbose", "--with-python=python3"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
    doc.install "doc/manual.asciidoc"
    elisp.install "misc/ninja-mode.el"
    (share/"vim/vimfiles/syntax").install "misc/ninja.vim"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    EOS
    system bin/"ninja", "-t", "targets"
    port = free_port
    fork do
      exec bin/"ninja", "-t", "browse", "--port=#{port}", "--hostname=127.0.0.1", "--no-browser", "foo.o"
    end
    sleep 15
    assert_match "foo.c", shell_output("curl -s http://127.0.0.1:#{port}?foo.o")
  end
end
