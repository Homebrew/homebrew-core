class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/1.0.32.tar.gz"
  sha256 "ce67a184aaeba66955c96f9f2d3353040b359c166329a149c49b470bf8edeb39"
  license "MIT"

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "mdless #{version}", shell_output("#{bin}/mdless --version")
    assert_match "first level title ===", shell_output("#{bin}/mdless --no-color -P <<<'# first level title'")
    assert_match "second level title ---", shell_output("#{bin}/mdless --no-color -P <<<'## second level title'")
  end
end
