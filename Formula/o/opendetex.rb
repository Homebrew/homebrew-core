class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/releases/download/v2.8.9/opendetex-2.8.9.tar.bz2"
  sha256 "0d6b8cb1f3394b790dd757b0171ad8b398c48e306fa6339e86ed8303c51df084"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed55ca17def1bdc6fec261be8ddb46618fb1a310170796d1ad90bfadbeeee68d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b7c22303e3de7519dc20cc7862c6aa3ac49fa6bae8d3bd043c46c3930dea810"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9416484618318a11e895667857e7d8b39598bc31c2c1d8fbdbb7914176345e5e"
    sha256 cellar: :any_skip_relocation, ventura:        "7562459cf4cb848fbc8ea3d3d1843355e6c200bb112890bf511ce9d67b6c61bd"
    sha256 cellar: :any_skip_relocation, monterey:       "18e2156648aac0c7429e14b30ebe1444cc6b95fd0ca99366fa39f81148bc5e17"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce26ea02e5c47385374aba395951434319d5e48e6dbda94f7ffa25e4632b54a6"
    sha256 cellar: :any_skip_relocation, catalina:       "46db3f033cb646e360fcabc83eb6fabba87b858eb1cc3e32d4bad78e73816bc6"
    sha256 cellar: :any_skip_relocation, mojave:         "92d55157d568aa004dd09342308f8e4be8dfb6a95f9719646c5d9792b677f7a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e88e075265c2480dd11436e5d6027a090fb8e199c51fb6e5ffb431db5bf1662c"
  end

  uses_from_macos "flex" => :build

  def install
    system "make"
    bin.install "detex"
    bin.install "delatex"
    man1.install "detex.1"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Simple \\emph{text}.
      \\end{document}
    EOS

    output = shell_output("#{bin}/detex test.tex")
    assert_equal "Simple text.\n", output
  end
end
