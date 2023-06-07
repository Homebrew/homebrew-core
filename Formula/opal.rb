class Opal < Formula
  desc "Ruby to JavaScript transpiler"
  homepage "https://opalrb.com/"
  url "https://github.com/opal/opal.git",
      tag:      "v1.7.3",
      revision: "a1a79a9ea893ed9cfe7086bb20a646a9a6b83cc0"
  license "MIT"
  head "https://github.com/opal/opal.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0770525b9220274fa50cf9ff0a16aa0c234d17c421461a3108b4dffe7059556d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0770525b9220274fa50cf9ff0a16aa0c234d17c421461a3108b4dffe7059556d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0770525b9220274fa50cf9ff0a16aa0c234d17c421461a3108b4dffe7059556d"
    sha256 cellar: :any_skip_relocation, ventura:        "0770525b9220274fa50cf9ff0a16aa0c234d17c421461a3108b4dffe7059556d"
    sha256 cellar: :any_skip_relocation, monterey:       "0770525b9220274fa50cf9ff0a16aa0c234d17c421461a3108b4dffe7059556d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0770525b9220274fa50cf9ff0a16aa0c234d17c421461a3108b4dffe7059556d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dea8efa3acb510fa6bbde473500e225f4a72875ce3f303271aede952b1ca2e4"
  end

  depends_on "quickjs" => :test

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    %w[opal opal-build opal-repl].each do |program|
      bin.install libexec/"bin/#{program}"
    end
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    (testpath/"test.rb").write "puts 'Hello world!'"
    assert_equal "Hello world!", shell_output("#{bin}/opal --runner quickjs test.rb").strip

    system bin/"opal", "--compile", "test.rb", "--output", "test.js"
    assert_equal "Hello world!", shell_output("#{Formula["quickjs"].opt_bin}/qjs test.js").strip
  end
end
