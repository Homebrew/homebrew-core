class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/v1.7.0.tar.gz"
  sha256 "3a4475fcce16acdb5bfc705641dbfc99ab7d8d7739de1da44d1f9c2fec8ea92d"
  head "https://github.com/simeg/eureka.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9dae88d4b997a0e28e4d6fc7df122230f81412092926f5b3853f2602161b458a" => :catalina
    sha256 "86b898e61753c4619889757477cc1cf0e54fd7db06b01531374ec6af1d33f648" => :mojave
    sha256 "97db80603a9c9c0bae1993da7c7ca53c0f5ccfefcc10a665b7257ed0cc8ce63a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "eureka [FLAGS]", shell_output("#{bin}/eureka --help 2>&1")

    (testpath/".eureka/repo_path").write <<~EOS
      homebrew
    EOS

    assert_match "homebrew/README.md: No such file or directory", shell_output("#{bin}/eureka --view 2>&1")
  end
end
