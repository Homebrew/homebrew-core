class Opal < Formula
  desc "Ruby to JavaScript transpiler"
  homepage "https://opalrb.com/"
  url "https://github.com/opal/opal.git",
      tag:      "v1.8.2",
      revision: "090897655fb1c0b9006a068012990375ead28049"
  license "MIT"
  head "https://github.com/opal/opal.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:    "ef42487ed8cae694f8d10dc826cfcd68c99f316f408382284b5ec4f176111d09"
    sha256                               arm64_sequoia:  "6c91211a8fdbeffb9335212d4d6f13cf42ba1710b74062e1dfe26a717c9db67c"
    sha256                               arm64_sonoma:   "a4cdd1358d5eb6508bf38cc2a67613a9e487cd250bdf9b35e85dea762894dffa"
    sha256                               arm64_ventura:  "0923489b028e208d184eeb4013e81ba78ab01e9fd76edd2d999f46998c01ccb8"
    sha256                               arm64_monterey: "faf628998eb0befec1ed127f51959fd57e12e5bd532aa47af4c8d142805fd734"
    sha256                               sonoma:         "0221fb61f196b9cf8d920dab63202bbd88a1cca1c39faeddc90eeb98809a7825"
    sha256                               ventura:        "c6d8ff163ca78c9704f439eb6028c9bfe886a8da9c33c954b4ecc6fb8ce63691"
    sha256                               monterey:       "5509432b1bde3b1c78431961c976f1a791c547620365e73b0be9368b7376b61a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5d5d252a73da8ef3044f0378d88d5dfb4d18a500fda114392cc3f6481fff46a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f250a308dd4b1ecfc9bab719bad3a47b2db363af2ca9642a3a81c1b6d9df815d"
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
