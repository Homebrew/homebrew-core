class Opal < Formula
  desc "Ruby to JavaScript transpiler"
  homepage "https://opalrb.com/"
  url "https://github.com/opal/opal.git",
      tag:      "v1.7.4",
      revision: "3c2076f81fe5813a4b65557cd82e1c60aa0a3424"
  license "MIT"
  head "https://github.com/opal/opal.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "fe981c8bdb30df18d92cbf643c425baa7ec3a906000b66d5bc6a2411f3b46af1"
    sha256                               arm64_ventura:  "b76cbd70f31e95fbf8c4ad29d346bcf3c2a5c16122d92951f1292b1f200c9218"
    sha256                               arm64_monterey: "ff085bf0b14a7fb6a660aa3f85749bab517bca88412ee7f304c034b89aa4e3ac"
    sha256                               arm64_big_sur:  "3c66c5c8ecf6710e0f031d85224a6f78229f28d6ff6863aa6e09abd5bc5bc46c"
    sha256                               sonoma:         "cc8cb2938787e88be2becc3b3139ab04bf69fe67404a0cf8ee93e7a89b0119b7"
    sha256                               ventura:        "c4aaae83eeebf5b776831ac1962e6ad7b1044498943420cf7de069869c617be8"
    sha256                               monterey:       "70c51cfc747978a3087ebd8d0d4e8b1371eaaf393196ce6aa2e28c290b0ba5d3"
    sha256                               big_sur:        "161697f10ac184bfe28bfd4f7e404cabac9e340f55da781f53df9ed6e0fdf366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e85f16a1624067635445e0a953b7bc6e1d280f89f2ae0ff5867930f36fe66ff4"
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
