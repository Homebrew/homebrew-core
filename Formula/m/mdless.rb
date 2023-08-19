class Mdless < Formula
  desc "Provides a formatted and highlighted view of Markdown files in Terminal"
  homepage "https://github.com/ttscoff/mdless"
  url "https://github.com/ttscoff/mdless/archive/refs/tags/1.0.33.tar.gz"
  sha256 "2b670b12e0d78b6dd31c9ca4732d81102f4a7da1ed61e4636b5abd235b3cbbc0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f2810b09d387761c2ba0fc6e7108646f9796e6793aa9219961266427c324ac3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f2810b09d387761c2ba0fc6e7108646f9796e6793aa9219961266427c324ac3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f2810b09d387761c2ba0fc6e7108646f9796e6793aa9219961266427c324ac3"
    sha256 cellar: :any_skip_relocation, ventura:        "8f2810b09d387761c2ba0fc6e7108646f9796e6793aa9219961266427c324ac3"
    sha256 cellar: :any_skip_relocation, monterey:       "8f2810b09d387761c2ba0fc6e7108646f9796e6793aa9219961266427c324ac3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f2810b09d387761c2ba0fc6e7108646f9796e6793aa9219961266427c324ac3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b51ebaaf29cd62425df969e9b4c1f96ee3514bd92c5d94a5f0b101a8b7ff0d7b"
  end

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
    (testpath/"test.md").write <<~EOS
      # title first level
      ## title second level
    EOS
    out = shell_output("#{bin}/mdless --no-color -P test.md")
    assert_match(/^title first level =+$/, out)
    assert_match(/^title second level -+$/, out)
  end
end
