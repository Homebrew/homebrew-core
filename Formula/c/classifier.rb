class Classifier < Formula
  desc "Text classification with Bayesian, LSI, Logistic Regression, and kNN"
  homepage "https://rubyclassifier.com"
  url "https://github.com/cardmagic/classifier/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "6909fa70e2aa9b368d67adea0514fac78d706df3f22d1a6fc7d73a4b649a4b2b"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "143f77e5d052057709e55f0cd20a8ce1d9ca2b9b8cb117a473273ea5a720a2cc"
    sha256 cellar: :any, arm64_sequoia: "c2f11321319b2fbad5bf48d3244e2ff849f7f32d6418467af07f0e8043627250"
    sha256 cellar: :any, arm64_sonoma:  "9b24561f59adf18abb08594ab4eeb681588968b9d1fec07198937d9ba43c6204"
    sha256 cellar: :any, sonoma:        "23bb5afa0cf18ed9f68fc2a106fef77c990ff5fce915fdb3440ff51731882169"
    sha256 cellar: :any, arm64_linux:   "8bcae9925e5c5257a8bce0b8c0d0d50017aee92f4c3124cdbc5d1acce09f5068"
    sha256 cellar: :any, x86_64_linux:  "455f272fb1c4eb361d8cc1ea0d15564803fa4f7f3e5124cfb16101bb36f29aa8"
  end

  depends_on "ruby"

  def install
    ENV["BUNDLE_FORCE_RUBY_PLATFORM"] = "1"
    ENV["BUNDLE_VERSION"] = "system"
    ENV["BUNDLE_WITHOUT"] = "development:test"
    ENV["GEM_HOME"] = libexec

    system "bundle", "install"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"

    bin.install libexec/"bin/classifier"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/classifier --version")

    # Test with pre-trained remote model (SMS spam detection)
    output = shell_output("#{bin}/classifier -r sms-spam-filter 'You won a free iPhone'")
    assert_match "spam", output.downcase

    output = shell_output("#{bin}/classifier -r sms-spam-filter 'Meeting at 3pm tomorrow'")
    assert_match "ham", output.downcase
  end
end
