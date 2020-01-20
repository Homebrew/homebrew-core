class Eureka < Formula
  desc "CLI tool to input and store your ideas without leaving the terminal"
  homepage "https://github.com/simeg/eureka"
  url "https://github.com/simeg/eureka/archive/v1.6.2.tar.gz"
  sha256 "a8fb41cdf0c8c5a00e5c17fd2cdde71ce8fa1babb2b5d69d68cee7a0df5d1b4b"
  head "https://github.com/simeg/eureka.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "eureka [FLAGS]", shell_output("#{bin}/eureka --help 2>&1")

    assert_match "Could not remove editor config file", shell_output("#{bin}/eureka --clear-editor 2>&1", 101)
    assert_match "No path to repository found", shell_output("#{bin}/eureka --view 2>&1", 101)
  end
end
