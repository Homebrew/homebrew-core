class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "974d6b2f4eeefa25625d34da3cb36bdcebe7fbce40f4c16ac0835fd1c0cbae17"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d311d593a271d255b4fd6337f8ef394f825b73aa77f7ebd51236ff850cf85033"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "700fe3bd75ca15b2778454947a215334a71997dcf92a3b644bfeb06f79c2508e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e137aa475dd45d513d0076971afb5f33314eb992ce27d868793ee5c54555cdcd"
    sha256 cellar: :any_skip_relocation, tahoe:         "158b6f8679eca7ea16e76aecddd42465e2bdc44512c4d9fdab579b50fe3c7301"
    sha256 cellar: :any_skip_relocation, sonoma:        "42222a304bd2a7d74e0af1479932821f4edb8855af4d0a89e2c0841e9a807b7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb6ac675ebb7a42d4dc01de374378df60f83f076211d5d35c0880da3babf40bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b3072c3b1944cb010705840243e7590cb1105445dfdcaf90de543b3dc06b545"
  end

  uses_from_macos "python" => [:build, :test]

  def install
    system "python3", "configure.py", "--bootstrap", "--verbose", "--with-python=python3"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
    doc.install "doc/manual.asciidoc"
    (share/"vim/vimfiles/syntax").install "misc/ninja.vim"
  end

  test do
    (testpath/"build.ninja").write <<~NINJA
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    NINJA
    system bin/"ninja", "-t", "targets"
    port = free_port
    fork do
      exec bin/"ninja", "-t", "browse", "--port=#{port}", "--hostname=127.0.0.1", "--no-browser", "foo.o"
    end
    sleep 15
    assert_match "foo.c", shell_output("curl -s http://127.0.0.1:#{port}?foo.o")
  end
end
