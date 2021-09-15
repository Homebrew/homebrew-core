class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https://ninja-build.org/"
  url "https://github.com/ninja-build/ninja/archive/v1.10.2.tar.gz"
  sha256 "ce35865411f0490368a8fc383f29071de6690cbadc27704734978221f25e2bed"
  license "Apache-2.0"
  head "https://github.com/ninja-build/ninja.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0daecb0cd98fd445d3150ab2b2408d519e4cb187c951928aca5c02856ca8d64f"
    sha256 cellar: :any_skip_relocation, big_sur:       "0314a25011cc9039cdef3b60fb5e4bc37c39fc8b728d072c23e01d3c611c1dd5"
    sha256 cellar: :any_skip_relocation, catalina:      "2f5c9cfca8ea739a46d4f7d8e17dee70c91ecc41e1caeb4e844fc20596cbd5fb"
    sha256 cellar: :any_skip_relocation, mojave:        "8a221f83054afbd1e50799f67d474b91e5232f2fd56d3ce7d46096d4660a9633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ec37aa6d5145de2f396926c75891b578883e2a078989969c011548cae2005cf"
  end

  depends_on "python@3.9"

  uses_from_macos "curl" => :test

  def install
    py = Formula["python@3.9"].opt_bin/"python3"
    system py, "./configure.py", "--bootstrap", "--verbose", "--with-python=python3"

    bin.install "ninja"
    bash_completion.install "misc/bash-completion" => "ninja-completion.sh"
    zsh_completion.install "misc/zsh-completion" => "_ninja"
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
      exec bin/"ninja", "-t", "browse", "--port=#{port}", "--no-browser", "foo.o"
    end
    sleep 2
    assert_match "foo.c", shell_output("curl -s http://localhost:#{port}?foo.o")
  end
end
