class Opal < Formula
  desc "Ruby to JavaScript transpiler"
  homepage "https://opalrb.com/"
  url "https://github.com/opal/opal.git",
      tag:      "v1.8.3",
      revision: "54a8bbbf582458b66ab3b52e68bbf2b73281751a"
  license "MIT"
  head "https://github.com/opal/opal.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "d0e1b504e4fd8a90d061deebf3b7d196179cfc538408ec6b70a25634a31a6659"
    sha256                               arm64_sequoia: "05ae63334332a7cbbfabb7754b46cf02b1611eed1c6759d0452c0e1c723c06f6"
    sha256                               arm64_sonoma:  "ac6753b6913583f8c9f2b3a32f457ab4baecdf39bacd7ed05b68e99a1a1ab5ff"
    sha256                               sonoma:        "49c4fab7a77ec600a1234f7a3c4313cb1082e1641b21c764f9c9322b4da55226"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a42c290b13d6f172e933b2b5433babf4f607dd818d55ce276f9bef95a04d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a42c290b13d6f172e933b2b5433babf4f607dd818d55ce276f9bef95a04d61"
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
