class Classifier < Formula
  desc "Text classification with Bayesian, LSI, Logistic Regression, and kNN"
  homepage "https://rubyclassifier.com"
  url "https://github.com/cardmagic/classifier/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "ce136ed8722fbc3efe111235be0bf1e60e92d766a5591270d7aecbe4e426878d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f517e272ef19b311e0442ac00be67c338065b8ff9e6c5ab59127fe5e6637d2b3"
    sha256 cellar: :any, arm64_sequoia: "4a6a04dab3f7be86c89c93d2824a464c780d42bedbba5239e7579fa4f1568d80"
    sha256 cellar: :any, arm64_sonoma:  "0eeca562dcb188671d290103eb1ad759d4823eb05894c4c69273401deddc2910"
    sha256 cellar: :any, sonoma:        "197a18f62032d8e1bef5d69abc8110c90ab004fe4e125fbd3a4a3bfcd42af124"
    sha256 cellar: :any, arm64_linux:   "65ccc8d691a314949f8657067a9c94cfdcd11bca0b6715778a16376ffc704c30"
    sha256 cellar: :any, x86_64_linux:  "3d969784bb27611af9ea46bc92639fb0f7f8077b2d14b79dabff3586d264f64f"
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
